// const edge = require('edge-js');
import edge from 'edge-js';

// Load the .NET assembly function
const GetICDConverterVersionAsync = edge.func({
    assemblyFile: 'DLLTEST.dll',
    typeName: 'DLLTEST.ICDCodeConverterWrapper',
    methodName: 'GetICDConverterVersionAsync'
});

const ICDConverterVersion = () => {
    return new Promise((resolve, reject) => {
        try {
            GetICDConverterVersionAsync({}, (error, result: any) => {
                if (error) {
                    console.error('Error:', error);
                    reject(error);
                } else {
                    console.log('ICD Converter Version:', result);
                    resolve({
                        ICDConverterVersionResult: result.Version
                    });
                }
            });
        } catch (error) {
            console.log('Error in JS:', error);
            reject(error);
        }
    });
};

export default ICDConverterVersion;