import { createLogger, transports, format } from 'winston';
import { isDev } from './config';

export default createLogger({
  level: isDev ? 'debug' : 'info',
  format: format.combine(
    format.colorize(),
    format.simple(),
  ),
  transports: [
    new transports.Console(),
  ],
});
