import { Application } from 'express';
import { getPrometheusMetrics } from '../loggers/prometheusClient';
import aiEngine from '../controllers/aiEngine';
import abrevioWebservice from '../controllers/abrevioWebservice';

const useRoutes = (app: Application): Application => {
    app.get('/AIM.AIengine.Webservices/Service.asmx', aiEngine);

    app.get('/Abrevio/Service.asmx', abrevioWebservice);

    app.get('/metrics', getPrometheusMetrics);

    return app;
};

export default useRoutes;
