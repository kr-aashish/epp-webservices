import aiEngineVersion from "../../aiEngine/getAiEngineVersion";

const soapService = {
    MyService: {
        MyPort: {
            AiEngineVersion: aiEngineVersion
        }
    }
};

export default soapService;