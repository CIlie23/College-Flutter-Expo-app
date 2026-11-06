import { FirebaseError } from 'firebase/app';
import { createUserWithEmailAndPassword, sendPasswordResetEmail, signInWithEmailAndPassword } from 'firebase/auth';
import { useState } from 'react';
import { ActivityIndicator, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { auth } from '../firebase';
import { useColors } from '../theme';

/** A Firebase error code, said the way a worker understands it. */
function messageFor(e: unknown): string {
  const code = e instanceof FirebaseError ? e.code : '';
  switch (code) {
    case 'auth/invalid-credential':
    case 'auth/user-not-found': // the Auth emulator (step 11) still answers with these two
    case 'auth/wrong-password':
      return 'Wrong email or password.';
    case 'auth/invalid-email':
      return 'That is not an email address.';
    case 'auth/email-already-in-use':
      return 'This email already has an account: sign in instead.';
    case 'auth/weak-password':
      return 'The password needs at least 6 characters.';
    case 'auth/network-request-failed':
      return 'No connection: signing in needs the network.';
    // Exercise 5: the rest of the codes a worker can meet.
    case 'auth/missing-password':
      return 'Type your password.';
    case 'auth/missing-email':
      return 'Type your email first.';
    case 'auth/too-many-requests':
      return 'Too many tries. Wait a few minutes, or reset your password.';
    case 'auth/user-disabled':
      return 'This account is switched off. Ask the office.';
    default:
      return `Could not sign in (${code || String(e)}).`;
  }
}

export function SignIn() {
  const colors = useColors();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  // No navigation here: onAuthStateChanged in the root layout swaps the screen.
  const run = async (how: typeof signInWithEmailAndPassword) => {
    setBusy(true);
    setError(null);
    try {
      await how(auth, email.trim(), password);
    } catch (e) {
      setError(messageFor(e));
    } finally {
      setBusy(false);
    }
  };

  // Exercise 5: a reset link by email. Firebase answers the same whether or not
  // the account exists (so nobody can probe emails), and so do we.
  const reset = async () => {
    setError(null);
    try {
      await sendPasswordResetEmail(auth, email.trim());
      setError('If an account exists for this email, a reset link is on its way.');
    } catch (e) {
      setError(messageFor(e));
    }
  };

  const input = [styles.input, { color: colors.text, borderColor: colors.muted }];
  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <Text style={[styles.title, { color: colors.text }]}>Field app — sign in</Text>
      <TextInput
        style={input}
        placeholder="Email"
        placeholderTextColor={colors.muted}
        autoCapitalize="none"
        autoComplete="email"
        keyboardType="email-address"
        value={email}
        onChangeText={setEmail}
      />
      <TextInput
        style={input}
        placeholder="Password"
        placeholderTextColor={colors.muted}
        secureTextEntry
        autoComplete="password"
        value={password}
        onChangeText={setPassword}
        onSubmitEditing={() => run(signInWithEmailAndPassword)}
      />
      {error && <Text style={styles.error}>{error}</Text>}
      {busy ? (
        <ActivityIndicator />
      ) : (
        <View style={styles.row}>
          <Pressable
            accessibilityRole="button"
            style={[styles.button, { backgroundColor: colors.primary }]}
            onPress={() => run(signInWithEmailAndPassword)}
          >
            <Text style={{ color: colors.onPrimary, fontWeight: '700' }}>Sign in</Text>
          </Pressable>
          <Pressable
            accessibilityRole="button"
            style={[styles.button, { borderColor: colors.primary, borderWidth: 1 }]}
            onPress={() => run(createUserWithEmailAndPassword)}
          >
            <Text style={{ color: colors.primary, fontWeight: '700' }}>Create account</Text>
          </Pressable>
        </View>
      )}
      <Pressable accessibilityRole="button" onPress={reset}>
        <Text style={{ color: colors.primary }}>Forgot your password?</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, justifyContent: 'center', padding: 24, gap: 12 },
  title: { fontSize: 22, fontWeight: '700', marginBottom: 8 },
  input: { borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, minHeight: 48, fontSize: 16 },
  error: { color: '#dc2626' },
  row: { flexDirection: 'row', gap: 12 },
  button: { flex: 1, minHeight: 48, borderRadius: 8, alignItems: 'center', justifyContent: 'center' },
});