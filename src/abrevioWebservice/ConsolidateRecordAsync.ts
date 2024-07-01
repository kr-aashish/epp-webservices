/* eslint-disable @typescript-eslint/no-explicit-any */
import edge from 'edge-js';
import path from 'path';
import logger from '../loggers/winstonLogger';
import {
    ConvertHL7V2TOV3Args,
    ConvertHL7V2TOV3Result
} from '../models/abrevioWebservice/convertHL7V2TOV3';

const consolidateVersion = async (
) => {
    // const { hl7v2 } = args;
    logger.info('consolidateVersion');

    const dllPath = path.join(
        __dirname,
        '..',
        'abrevioWebservice',
        'DLLs',
        'DLLTEST.dll'
    );
    const ConsolidateRecordAsync = edge.func({
        assemblyFile: 'DLLTEST.dll',
        typeName: 'DLLTEST.RecordConsolidatorWrapper',
        methodName: 'ConsolidateRecordAsync'
    });

    const v2CodeUpdateSetting = null;

    try {
        const result = await new Promise<any>((resolve, reject) => {
            ConsolidateRecordAsync({}, (error, result) => {
                if (error) {
                    console.error('Error:', error);
                    reject(error);
                } else {
                    console.log('Record Consolidator Version:', result);
                    resolve(result);
                }
            });
        });

        logger.info(result);
        return { consolidateVersionResult: result.Version };
    } catch (error: any) {
        logger.error(error);
        const response: ConvertHL7V2TOV3Result = {
            covertHL7V2TOV3Result: 'Failure',
            version: '3.0',
            error: error.message
        };
        return response;
    }
};

export default consolidateVersion;
