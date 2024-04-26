import ViewHome from './views/home'
import View404 from './views/404'
import { VNode } from 'hyperapp';
import type { State } from '../client';

export const routes: Record<string, (state: State) => VNode<State>> = {
  '/': ViewHome,
  '404': View404,
};

export default (state: State) => (routes[state.url.pathname] ?? routes["404"])(state);
