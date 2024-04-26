import h from 'hyperapp-jsx-pragma';
import type { State } from '../../client';

export default (props: object, children: array) => (
  <div class="bg-white rounded-md space-x-4 space-y-4">
    {children}
  </div>
);
