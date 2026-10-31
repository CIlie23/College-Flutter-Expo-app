import { useForm } from '@tanstack/react-form';
import * as Haptics from 'expo-haptics';
import { router, useLocalSearchParams } from 'expo-router';
import { Pressable, StyleSheet, Switch, Text, TextInput, View, AppState } from 'react-native';
import { KeyboardAwareScrollView } from 'react-native-keyboard-controller';
import { type Entrance, EntranceSurvey } from '../../contract/contract';
import { locate } from '../../location';
import { submitSurvey, useEntrance } from '../../store';
import { type Colors, useColors } from '../../theme';
import Storage from 'expo-sqlite/kv-store';
import { type ReactNode, useEffect, useMemo } from 'react';


// An empty number box is NaN, which the schema refuses ("expected number").
const toNumber = (text: string) => (text.trim() === '' ? Number.NaN : Number(text));
const toNullable = (text: string) => (text.trim() === '' ? null : Number(text));
const fromNumber = (n: number | null) =>
  n === null || Number.isNaN(n) ? '' : String(n);

export default function SurveyScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const entrance = useEntrance(id);
  // The row comes from SQLite just after the first render: build the form
  // only once it is here, so the form's default values are the entrance's.
  if (!entrance) return null;
  return <SurveyForm id={id} entrance={entrance} />;
}

function SurveyForm({ id, entrance }: { id: string; entrance: Entrance }) {
  const colors = useColors();

  const draftKey = `field.draft.${id}`;
  const draft = useMemo(() => {
    const saved = Storage.getItemSync(draftKey);
    return saved ? JSON.parse(saved) : null;
  }, [draftKey]);

  const form = useForm({
    defaultValues: draft ?? {
      coordsConfirmed: entrance?.coordsConfirmed ?? false,
      correctedLat: entrance?.correctedLat ?? null,
      correctedLng: entrance?.correctedLng ?? null,
      street: entrance?.street ?? '',
      number: entrance?.number ?? '',
      entranceName: entrance?.entranceName ?? '',
      addressConfirmed: entrance?.addressConfirmed ?? false,
      stories: entrance?.stories ?? Number.NaN,
      flats: entrance?.flats ?? Number.NaN,
      elevators: entrance?.elevators ?? Number.NaN,
      yearBuilt: entrance?.yearBuilt ?? Number.NaN,
      groundFloorCommercial: entrance?.groundFloorCommercial ?? false,
      comment: entrance?.comment ?? null,
    },
    // The contract's own schema validates the whole form on every change.
    validators: { onChange: EntranceSurvey },
    onSubmit: async ({ value }) => {
      await submitSurvey(id, EntranceSurvey.parse(value));
      Storage.removeItemSync(draftKey); // submitted: the draft is done
      // Saved: say it with the hand as well as the eyes (a no-op on the web).
      await Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
      router.back();
    },
  });

  // Exercise 4: the phone may kill an app in the background without warning,
  // so write what was typed when the app leaves the screen.
  useEffect(() => {
    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'background') Storage.setItemSync(draftKey, JSON.stringify(form.state.values));
    });
    return () => sub.remove();
  }, [form, draftKey]);

  const input = [styles.input, { color: colors.text, borderColor: colors.border }];

  return (
    // Edge to edge, Android no longer shrinks the window for the keyboard:
    // this ScrollView scrolls the focused field above it, on both platforms.
    <KeyboardAwareScrollView
      // The caret stays 80 dp above the keyboard: enough to show the whole comment box.
      bottomOffset={80}
      keyboardShouldPersistTaps="handled"
      style={{ flex: 1, backgroundColor: colors.background }}
    >
      <View style={styles.content}>
        <form.Field name="coordsConfirmed">
          {(field) => (
            <Row label="The pin is at the door" colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
              <Switch value={field.state.value} onValueChange={field.handleChange} />
            </Row>
          )}
        </form.Field>
        <form.Subscribe selector={(s) => s.values.coordsConfirmed}>
          {(confirmed) =>
            confirmed ? null : (
              <View style={styles.pair}>
                <form.Field name="correctedLat">
                  {(field) => (
                    <Labeled label="Corrected latitude" colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
                      <TextInput style={input} keyboardType="decimal-pad" value={fromNumber(field.state.value)} onChangeText={(t) => field.handleChange(toNullable(t))} onBlur={field.handleBlur} />
                    </Labeled>
                  )}
                </form.Field>
                <form.Field name="correctedLng">
                  {(field) => (
                    <Labeled label="Corrected longitude" colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
                      <TextInput style={input} keyboardType="decimal-pad" value={fromNumber(field.state.value)} onChangeText={(t) => field.handleChange(toNullable(t))} onBlur={field.handleBlur} />
                    </Labeled>
                  )}
                </form.Field>
                <Pressable
                  accessibilityRole="button"
                  onPress={async () => {
                    const fix = await locate();
                    if (!fix) return;
                    // Five decimals is about a metre: more would be false precision.
                    form.setFieldValue('correctedLat', Number(fix.lat.toFixed(5)));
                    form.setFieldValue('correctedLng', Number(fix.lng.toFixed(5)));
                  }}
                  style={[styles.outline, { borderColor: colors.primary }]}
                >
                  <Text style={{ color: colors.primary, fontWeight: '700' }}>
                    Use my position
                  </Text>
                </Pressable>
              </View>
            )
          }
        </form.Subscribe>

        {(['street', 'number', 'entranceName'] as const).map((name) => (
          <form.Field key={name} name={name}>
            {(field) => (
              <Labeled label={{ street: 'Street', number: 'Number', entranceName: 'Entrance' }[name]} colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
                <TextInput style={input} value={field.state.value} onChangeText={field.handleChange} onBlur={field.handleBlur} />
              </Labeled>
            )}
          </form.Field>
        ))}
        <form.Field name="addressConfirmed">
          {(field) => (
            <Row label="I checked the address" colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
              <Switch value={field.state.value} onValueChange={field.handleChange} />
            </Row>
          )}
        </form.Field>

        {(
          [
            ['stories', 'Stories'],
            ['flats', 'Flats'],
            ['elevators', 'Elevators'],
            ['yearBuilt', 'Year built'],
          ] as const
        ).map(([name, label]) => (
          <form.Field key={name} name={name}>
            {(field) => (
              <Labeled label={label} colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
                <TextInput style={input} keyboardType="number-pad" value={fromNumber(field.state.value)} onChangeText={(t) => field.handleChange(toNumber(t))} onBlur={field.handleBlur} />
              </Labeled>
            )}
          </form.Field>
        ))}
        <form.Field name="groundFloorCommercial">
          {(field) => (
            <Row label="Shops on the ground floor" colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
              <Switch value={field.state.value} onValueChange={field.handleChange} />
            </Row>
          )}
        </form.Field>
        <form.Field name="comment">
          {(field) => (
            <Labeled label="Comment" colors={colors} errors={field.state.meta.errors} touched={field.state.meta.isTouched}>
              <TextInput style={[input, styles.multiline]} multiline value={field.state.value ?? ''} onChangeText={(t) => field.handleChange(t === '' ? null : t)} onBlur={field.handleBlur} />
            </Labeled>
          )}
        </form.Field>

        <form.Subscribe selector={(s) => [s.canSubmit, s.isSubmitting] as const}>
          {([canSubmit, isSubmitting]) => (
            <Pressable
              accessibilityRole="button"
              accessibilityState={{ disabled: !canSubmit }}
              disabled={!canSubmit || isSubmitting}
              onPress={() => form.handleSubmit()}
              style={[styles.button, { backgroundColor: canSubmit ? colors.primary : colors.border }]}
            >
              <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>Submit survey</Text>
            </Pressable>
          )}
        </form.Subscribe>
      </View>
    </KeyboardAwareScrollView>
  );
}

type FieldProps = {
  label: string;
  colors: Colors;
  errors: unknown[];
  touched: boolean;
  children: ReactNode;
};

/** Errors show once the user has touched the field (or pressed Submit). */
function Errors({ errors, touched, colors }: Omit<FieldProps, 'label' | 'children'>) {
  if (!touched || errors.length === 0) return null;
  const text = errors
    .map((e) => (typeof e === 'object' && e && 'message' in e ? String(e.message) : String(e)))
    .join(' · ');
  return <Text style={{ color: colors.error }}>{text}</Text>;
}

function Labeled({ label, colors, children, ...rest }: FieldProps) {
  return (
    <View style={styles.field}>
      <Text style={{ color: colors.muted }}>{label}</Text>
      {children}
      <Errors colors={colors} {...rest} />
    </View>
  );
}

function Row({ label, colors, children, ...rest }: FieldProps) {
  return (
    <View style={styles.field}>
      <View style={styles.row}>
        <Text style={{ color: colors.text, flex: 1 }}>{label}</Text>
        {children}
      </View>
      <Errors colors={colors} {...rest} />
    </View>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16, gap: 14 },
  field: { gap: 4 },
  row: { flexDirection: 'row', alignItems: 'center', minHeight: 48 },
  pair: { gap: 14 },
  input: { borderWidth: 1, borderRadius: 10, paddingHorizontal: 12, minHeight: 48, fontSize: 16 },
  multiline: { minHeight: 96, textAlignVertical: 'top', paddingTop: 12 },
  outline: { minHeight: 48, borderWidth: 2, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
  button: { minHeight: 52, borderRadius: 12, alignItems: 'center', justifyContent: 'center', marginTop: 8 },
});