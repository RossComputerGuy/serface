import { h, text } from 'hyperapp'
import type { State } from '../../client';

export default (state: State) => h('div', {}, [
  h('h1', {}, text('Page not found')),
  h('p', {}, text(`The requested page (${state.url.pathname}) could not be found.`)),
]);
