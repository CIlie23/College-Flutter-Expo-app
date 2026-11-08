import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A Firebase error code, said the way a worker understands it.
String messageFor(Object e) {
  final code = e is FirebaseAuthException ? e.code : '';
  return switch (code) {
    'invalid-credential' ||
    'user-not-found' ||
    'wrong-password' => 'Wrong email or password.',
    'invalid-email' => 'That is not an email address.',
    'email-already-in-use' =>
      'This email already has an account: sign in instead.',
    'weak-password' => 'The password needs at least 6 characters.',
    'network-request-failed' => 'No connection: signing in needs the network.',
    _ => 'Could not sign in (${code.isEmpty ? e : code}).',
  };
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // No navigation here: authStateChanges() in main.dart swaps the screen.
  Future<void> _run(
    Future<UserCredential> Function({
      required String email,
      required String password,
    })
    how,
  ) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await how(email: _email.text.trim(), password: _password.text);
    } catch (e) {
      setState(() => _error = messageFor(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 48),
            Text(
              'Field app — sign in',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _run(auth.signInWithEmailAndPassword),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            if (_busy)
              const Center(child: CircularProgressIndicator())
            else
              Wrap(
                spacing: 12,
                children: [
                  FilledButton(
                    onPressed: () => _run(auth.signInWithEmailAndPassword),
                    child: const Text('Sign in'),
                  ),
                  OutlinedButton(
                    onPressed: () => _run(auth.createUserWithEmailAndPassword),
                    child: const Text('Create account'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
