import convertHL7V2TOV3 from '../../abrevioWebservice/convertHL7V2TOV3';
import csvDeIdentifyProcessor from '../../abrevioWebservice/csvDeIdentifyProcessor';

const soapService = {
    MyService: {
        MyPort: {
            CSVDeIdentifyProcessor: csvDeIdentifyProcessor,
            covertHL7V2TOV3: convertHL7V2TOV3
        }
    }
};

export default soapService;
