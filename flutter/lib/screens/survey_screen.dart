import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../contract/contract.dart';
import '../location.dart';
import '../providers.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Entrance _entrance;
  late bool _coordsConfirmed, _addressConfirmed, _groundFloorCommercial;
  late final Map<String, TextEditingController> _text;
  Map<String, String> _ruleErrors = {};

  // Exercise 4: what was typed, saved when the app leaves the screen.
  final _prefs = SharedPreferencesAsync();
  late final AppLifecycleListener _lifecycle;
  Map<String, dynamic>? _draft;
  bool _draftRead = false;
  String get _draftKey => 'field.draft.${widget.id}';

  @override
  void initState() {
    super.initState();
    _text = {};
    // The phone may kill an app in the background without warning: onHide is
    // the last moment we are sure to run.
    _lifecycle = AppLifecycleListener(onHide: _saveDraft);
    _prefs.getString(_draftKey).then((saved) => setState(() {
          _draft = saved == null ? null : jsonDecode(saved) as Map<String, dynamic>;
          _draftRead = true;
        }));
  }

  Future<void> _saveDraft() async {
    if (_text.isEmpty) return;
    await _prefs.setString(_draftKey, jsonEncode({
      for (final MapEntry(:key, :value) in _text.entries) key: value.text,
      'coordsConfirmed': _coordsConfirmed,
      'addressConfirmed': _addressConfirmed,
      'groundFloorCommercial': _groundFloorCommercial,
    }));
  }

  void _init(Entrance e) {
    _entrance = e;
    _coordsConfirmed = e.coordsConfirmed;
    _addressConfirmed = e.addressConfirmed;
    _groundFloorCommercial = e.groundFloorCommercial ?? false;
    String s(Object? v) => v == null ? '' : '$v';
    _text.addAll({
      'correctedLat': TextEditingController(text: s(e.correctedLat)),
      'correctedLng': TextEditingController(text: s(e.correctedLng)),
      'street': TextEditingController(text: e.street),
      'number': TextEditingController(text: e.number),
      'entranceName': TextEditingController(text: e.entranceName),
      'stories': TextEditingController(text: s(e.stories)),
      'flats': TextEditingController(text: s(e.flats)),
      'elevators': TextEditingController(text: s(e.elevators)),
      'yearBuilt': TextEditingController(text: s(e.yearBuilt)),
      'comment': TextEditingController(text: e.comment ?? ''),
    });
    // A draft from an earlier visit wins over the row.
    if (_draft case final d?) {
      for (final MapEntry(:key, :value) in _text.entries) {
        if (d[key] is String) value.text = d[key] as String;
      }
      _coordsConfirmed = d['coordsConfirmed'] as bool? ?? _coordsConfirmed;
      _addressConfirmed = d['addressConfirmed'] as bool? ?? _addressConfirmed;
      _groundFloorCommercial = d['groundFloorCommercial'] as bool? ?? _groundFloorCommercial;
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  int? _int(String key) => int.tryParse(_text[key]!.text.trim());
  double? _double(String key) => double.tryParse(_text[key]!.text.trim());

  /// The form's values as an entrance, so the contract can check the rules
  /// that span several fields.
  Entrance _candidate() => Entrance(
        id: _entrance.id,
        createdAt: _entrance.createdAt,
        updatedAt: _entrance.updatedAt,
        buildingId: _entrance.buildingId,
        lat: _entrance.lat,
        lng: _entrance.lng,
        street: _text['street']!.text.trim(),
        number: _text['number']!.text.trim(),
        entranceName: _text['entranceName']!.text.trim(),
        coordsConfirmed: _coordsConfirmed,
        correctedLat: _coordsConfirmed ? null : _double('correctedLat'),
        correctedLng: _coordsConfirmed ? null : _double('correctedLng'),
        addressConfirmed: _addressConfirmed,
        stories: _int('stories'),
        flats: _int('flats'),
        elevators: _int('elevators'),
        yearBuilt: _int('yearBuilt'),
        groundFloorCommercial: _groundFloorCommercial,
        comment: _text['comment']!.text.trim().isEmpty ? null : _text['comment']!.text.trim(),
        surveyStatus: _entrance.surveyStatus,
        surveyedBy: _entrance.surveyedBy,
        surveyedAt: _entrance.surveyedAt,
      );

  Future<void> _submit() async {
    final fieldsOk = _formKey.currentState!.validate();
    final candidate = _candidate();
    // validateEntranceSurvey returns "field: message" strings.
    final rules = <String, String>{
      for (final err in validateEntranceSurvey(candidate))
        err.split(':').first: err.split(': ').skip(1).join(': '),
    };
    setState(() => _ruleErrors = rules);
    if (!fieldsOk || rules.isNotEmpty) return;
    await ref.read(databaseProvider).submitSurvey(candidate, ref.read(meProvider));
    // Saved: say it with the hand as well as the eyes (nothing happens on the web).
    await _prefs.remove(_draftKey); // submitted: the draft is done
    await HapticFeedback.mediumImpact();
    if (mounted) context.pop();
  }

  // A text field whose validator is the contract's.
  Widget _field(String key, String label, String? Function(String?) validator,
          {TextInputType? keyboard}) =>
      TextFormField(
        controller: _text[key],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: keyboard,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      );

  String? Function(String?) _intRule(String? Function(int?) rule) =>
      (s) => (s ?? '').trim().isNotEmpty && int.tryParse(s!.trim()) == null
          ? 'A whole number'
          : rule(int.tryParse((s ?? '').trim()));

  String? Function(String?) _coordRule(String? Function(num?) rule) =>
      (s) => (s ?? '').trim().isEmpty ? null : rule(double.tryParse(s!.trim()) ?? double.nan);

  @override
  Widget build(BuildContext context) {
    if (!_draftRead) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_text.isEmpty) {
      // The row comes from SQLite a moment after the first build: fill the
      // form's controllers only once it is here.
      final found = ref.watch(entranceProvider(widget.id));
      if (found.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      final e = found.value;
      if (e == null) return const Scaffold(body: Center(child: Text('No such entrance.')));
      _init(e);
    }
    const gap = SizedBox(height: 14);
    const number = TextInputType.number;
    const decimal = TextInputType.numberWithOptions(decimal: true, signed: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Survey')),
      // The body scrolls, so the keyboard never hides the field being typed.
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          // Drag the list to put the keyboard away. The Scaffold already shrinks
          // the body above the keyboard and scrolls the focused field into view.
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SwitchListTile(
              title: const Text('The pin is at the door'),
              subtitle: _ruleError('coordsConfirmed'),
              value: _coordsConfirmed,
              onChanged: (v) => setState(() => _coordsConfirmed = v),
            ),
            if (!_coordsConfirmed) ...[
              _field('correctedLat', 'Corrected latitude', _coordRule(validateLat), keyboard: decimal),
              gap,
              _field('correctedLng', 'Corrected longitude', _coordRule(validateLng), keyboard: decimal),
              if (_ruleErrors['correctedLng'] != null) _ruleError('correctedLng')!,
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () async {
                  final fix = await locate(context, ref);
                  if (fix == null) return;
                  // Five decimals is about a metre: more would be false precision.
                  _text['correctedLat']!.text = fix.lat.toStringAsFixed(5);
                  _text['correctedLng']!.text = fix.lng.toStringAsFixed(5);
                },
                child: const Text('Use my position'),
              ),
              gap,
            ],
            _field('street', 'Street', validateStreet),
            gap,
            _field('number', 'Number', validateStreetNumber),
            gap,
            _field('entranceName', 'Entrance', validateEntranceName),
            SwitchListTile(
              title: const Text('I checked the address'),
              subtitle: _ruleError('addressConfirmed'),
              value: _addressConfirmed,
              onChanged: (v) => setState(() => _addressConfirmed = v),
            ),
            _field('stories', 'Stories', _intRule(validateStories), keyboard: number),
            gap,
            _field('flats', 'Flats', _intRule(validateFlats), keyboard: number),
            gap,
            _field('elevators', 'Elevators', _intRule(validateElevators), keyboard: number),
            gap,
            _field('yearBuilt', 'Year built', _intRule(validateYearBuilt), keyboard: number),
            SwitchListTile(
              title: const Text('Shops on the ground floor'),
              value: _groundFloorCommercial,
              onChanged: (v) => setState(() => _groundFloorCommercial = v),
            ),
            TextFormField(
              controller: _text['comment'],
              decoration: const InputDecoration(labelText: 'Comment', border: OutlineInputBorder()),
              maxLines: 4,
              validator: validateFreeText,
            ),
            gap,
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              onPressed: _submit,
              child: const Text('Submit survey'),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _ruleError(String key) {
    final message = _ruleErrors[key];
    if (message == null) return null;
    return Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error));
  }
}
