import edge from 'edge-js';
import logger from '../loggers/winstonLogger';
import { ConvertHL7V2TOV3Args, ConvertHL7V2TOV3Result } from '../models/abrevioWebservice/convertHL7V2TOV3';
import path from 'path';

const convertHL7V2TOV3 = async (args: ConvertHL7V2TOV3Args): Promise<ConvertHL7V2TOV3Result> => {
    const { hl7v2 } = args;
    logger.info('convertHL7V2TOV3');

    const dllPath = path.join(__dirname, '..', 'abrevioWebservice', 'DLLs', 'DLLTEST.dll');
    const convertHL7V2ToV3Async = edge.func({
        assemblyFile: dllPath,
        typeName: 'DLLTEST.DLLTEST',
        methodName: 'ConvertHL7V2ToV3Async'
    });

    const v2CodeUpdateSetting = null;
    const params = {
        hl7v2: hl7v2,
        v2CodeUpdateSetting: v2CodeUpdateSetting
    };

    try {
        const result = await new Promise<any>((resolve, reject) => {
            convertHL7V2ToV3Async(params, (error: Error, result: any) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            });
        });

        logger.info(result.HL7V3);
        const response: ConvertHL7V2TOV3Result = {
            covertHL7V2TOV3Result: "Success",
            version: '3.0',
            hl7v3: result.HL7V3
        };
        return response;

    } catch (error: any) {
        logger.error(error);
        const response: ConvertHL7V2TOV3Result = {
            covertHL7V2TOV3Result: "Failure",
            version: '3.0',
            error: error.message
        };
        return response;
    }
};

export default convertHL7V2TOV3;