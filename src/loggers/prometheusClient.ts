import client from 'prom-client';
import { Request, Response } from 'express';

const { collectDefaultMetrics } = client;

const initialisePrometheusClient = async () => {
    collectDefaultMetrics({
        register: client.register
    });
};

const getPrometheusMetrics = async (req: Request, res: Response) => {
    res.set('Content-Type', client.register.contentType);
    const metrics = await client.register.metrics();
    res.end(metrics);
};

const reqResTime = new client.Histogram({
    name: 'http_express_req_res_time',
    help: 'Request response time in ms',
    labelNames: ['method', 'route', 'body', 'query', 'status_code'],
    buckets: [1, 50, 100, 200, 400, 500, 800, 1000, 2000, 5000]
});

const totalReqCounter = new client.Counter({
    name: 'total_req',
    help: 'Total number of requests'
});

export {
    initialisePrometheusClient,
    getPrometheusMetrics,
    reqResTime,
    totalReqCounter
};
