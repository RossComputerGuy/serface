const parseBool = (str) => str == 'true';

export const isSsr = parseBool(process.env.IS_SSR ?? 'false');
export const env = process.env.NODE_ENV ?? 'dev';
export const isDev = env.startsWith('dev');
