import type { Message } from './contract/contract';
import { ME, conversations, messages, users } from './contract/fixtures';

/** Unread for me: written by someone else, and my id is not in readAt. */
export const isUnread = (m: Message) => m.authorId !== ME && !m.readAt[ME];

export const myConversations = conversations.filter((c) =>
  c.participantIds.includes(ME),
);

export const messagesOf = (conversationId: string) =>
  messages
    .filter((m) => m.conversationId === conversationId)
    .sort((a, b) => a.sentAt.localeCompare(b.sentAt));

export const nameOf = (userId: string) =>
  users.find((u) => u.id === userId)?.name ?? 'Unknown';

export const totalUnread = myConversations
  .flatMap((c) => messagesOf(c.id))
  .filter(isUnread).length;