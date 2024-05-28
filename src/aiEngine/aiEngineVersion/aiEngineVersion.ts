import logger from "../../loggers/winstonLogger";

const aiEngineVersion = () => {
    logger.info('getAiEngineVersion');  
    return {
        AiEngineVersionResult: '4.1.72.14'
    };
}

export default aiEngineVersion;