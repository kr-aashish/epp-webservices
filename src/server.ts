import http from 'http';
import dotenv from 'dotenv';
import { Application } from 'express';
import * as soap from 'soap';
import logger from './loggers/winstonLogger';
import { initialisePrometheusClient } from './loggers/prometheusClient';
import aiEngineWsdl from './services/aiEngine/getWsdlContents';
import abrevioWebserviceWsdl from './services/abrevioWebservice/getWsdlContents';
import aiEngineSoapService from './services/aiEngine/soapService';
import abrevioSoapService from './services/abrevioWebservice/soapService';

process.env.NODE_ENV ? dotenv.config({path: `.env.${process.env.NODE_ENV}`}) : dotenv.config({path: `.env.dev`});

const startServer = async (app: Application) => {
    const port = Number(process.env.API_SERVER_PORT);
    const aiEngineEndpoint = `/api/${process.env.API_VERSION}/${process.env.AI_ENGINE_PREFIX}`;
    const abrevioWebserviceEndpoint = `/api/${process.env.API_VERSION}/${process.env.ABREVIO_WEBSERVICE_PREFIX}`;

    const server = http.createServer(app);

    soap.listen(server, aiEngineEndpoint, aiEngineSoapService, aiEngineWsdl, () => {
        logger.info(`AI Engine Service is listening on ${aiEngineEndpoint}`);
    });

    soap.listen(server, abrevioWebserviceEndpoint, abrevioSoapService, abrevioWebserviceWsdl, () => {
        logger.info(`Abrevio Webservice is listening on ${abrevioWebserviceEndpoint}`);
    });

    server
        .listen(port, () => logger.info(`Listening to port ${port}`))
        .on('error', (err) => {
            logger.error(err.message);
            process.exit();
        });

    initialisePrometheusClient();
};

export default startServer;
