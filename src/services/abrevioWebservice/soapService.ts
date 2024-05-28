import csvDeIdentifyProcessor from "../../abrevioWebservice/csvDeIdentifyProcessor";

const soapService = {
    MyService: {
        MyPort: {
            CSVDeIdentifyProcessor: csvDeIdentifyProcessor
        }
    }
};

export default soapService;