import winston from 'winston';
import LokiTransport from 'winston-loki';

export default class Logger {
    private static loggers: Record<string, winston.Logger> = {};

    private static getLogger(level: string, filename: string): winston.Logger {
        if (!Logger.loggers[level]) {
            const logTransport = new winston.transports.File({
                filename: `logs/${filename}.log`,
                level
            });
            const consoleTransport = new winston.transports.Console();

            const customTransport: (
                | winston.transports.FileTransportInstance
                | winston.transports.ConsoleTransportInstance
                | LokiTransport
            )[] = [logTransport];

            if (process.env.NODE_ENV !== 'test') {
                customTransport.push(consoleTransport);

                customTransport.push(
                    new LokiTransport({
                        labels: {
                            appName: 'epp-api-node'
                        },
                        host: 'http://127.0.0.1:3100'
                    })
                );
            }

            Logger.loggers[level] = winston.createLogger({
                level,
                format: winston.format.combine(
                    winston.format.colorize({
                        all: true
                    }),
                    winston.format.timestamp({
                        format: 'YYYY-MM-DD hh:mm:ss.SSS A'
                    }),
                    winston.format.printf(({ timestamp, message }) => {
                        const logGroup = level === 'info' ? 'Info' : 'Error';
                        return `${timestamp} ${logGroup}: ${message}`;
                    })
                ),
                transports: customTransport
            });
        }

        return Logger.loggers[level];
    }

    static info(message: string) {
        const logger = Logger.getLogger('info', 'info');
        logger.log({ level: 'info', message });
    }

    static error(message: string) {
        const logger = Logger.getLogger('error', 'error');
        logger.log({ level: 'error', message });
    }
}
