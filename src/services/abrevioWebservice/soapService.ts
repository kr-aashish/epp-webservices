import consolidateVersion from '../../abrevioWebservice/ConsolidateRecordAsync';
import ICDConverterVersion from '../../abrevioWebservice/GetICDConverterVersionAsync';
import convertHL7V2TOV3 from '../../abrevioWebservice/convertHL7V2TOV3';
import csvDeIdentifyProcessor from '../../abrevioWebservice/csvDeIdentifyProcessor';

const soapService = {
    MyService: {
        MyPort: {
            CSVDeIdentifyProcessor: csvDeIdentifyProcessor,
            covertHL7V2TOV3: convertHL7V2TOV3,
            consolidateVersion: consolidateVersion,
            ICDConverterVersion: ICDConverterVersion
        }
    }
};

export default soapService;
