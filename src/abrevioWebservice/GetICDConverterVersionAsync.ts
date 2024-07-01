// const edge = require('edge-js');
import edge from 'edge-js';

// Load the .NET assembly function
const GetICDConverterVersionAsync = edge.func({
    assemblyFile: 'DLLTEST.dll',
    typeName: 'DLLTEST.ICDCodeConverterWrapper',
    methodName: 'GetICDConverterVersionAsync'
});

const ICDConverterVersion = async () => {
    // Call the .NET method asynchronously without parameters
    try {
        // console.log('Start Time:', startTime.toISOString());
        GetICDConverterVersionAsync({}, (error: any, result: any) => {
            if (error) {
                console.error('Error:', error);
            } else {
                console.log('ICD Converter Version:', result);
            }

            return {
                ICDConverterVersionResult: result.Version
            }
        });
    } catch (error) {
        console.log('Error in JS:', error);
    }
}

export default ICDConverterVersion;