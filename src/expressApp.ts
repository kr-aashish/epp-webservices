import express, { Application, Request, Response } from 'express';
import responseTime from 'response-time';

import routes from './routes';
import { reqResTime, totalReqCounter } from './loggers/prometheusClient';

const initialiseExpressApp = async () => {
    let app: Application = express();

    app.use(
        responseTime((req: Request, res: Response, time: number) => {
            totalReqCounter.inc();
            reqResTime
                .labels({
                    method: req.method,
                    route: req.baseUrl,
                    body: JSON.stringify(req.body),
                    query: JSON.stringify(req.query),
                    status_code: res.statusCode
                })
                .observe(time);
        })
    );

    app = routes(app);

    return app;
};

export default initialiseExpressApp;
