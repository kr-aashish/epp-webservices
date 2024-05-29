import logger from '../loggers/winstonLogger';

const csvDeIdentifyProcessor = (args: string) => {
    logger.info(args);
    logger.info('csvDeIdentifyProcessor');

    const processedCSV = 'Processed CSV content';

    const response = {
        CSVDeIdentifyProcessorResult: processedCSV,
        successful: true,
        errormessage: ''
    };

    return response;
};

export default csvDeIdentifyProcessor;
