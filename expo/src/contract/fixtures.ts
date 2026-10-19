import { z } from 'zod';
import {
  Building,
  Conversation,
  Entrance,
  Message,
  Route,
  RouteStop,
  User,
} from './contract';
import buildingsJson from './fixtures/buildings.json';
import conversationsJson from './fixtures/conversations.json';
import entrancesJson from './fixtures/entrances.json';
import messagesJson from './fixtures/messages.json';
import routesJson from './fixtures/routes.json';
import usersJson from './fixtures/users.json';

// Every fixture goes through its schema once, at start-up: a typo in a JSON
// file fails loudly here instead of somewhere deep in a screen.
export const users = z.array(User).parse(usersJson);
export const buildings = z.array(Building).parse(buildingsJson);
export const entrances = z.array(Entrance).parse(entrancesJson);
export const routes = z
  .array(Route.extend({ stops: z.array(RouteStop) }))
  .parse(routesJson);
export const conversations = z.array(Conversation).parse(conversationsJson);
export const messages = z.array(Message).parse(messagesJson);

/** Who is "signed in" until week 4: the worker of the first route. */
export const ME = routes[0].workerId;