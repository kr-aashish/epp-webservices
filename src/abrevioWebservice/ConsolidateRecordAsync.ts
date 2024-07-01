// const edge = require('edge-js');
import edge from 'edge-js';

// Load the .NET assembly function
const ConsolidateRecordAsync = edge.func({
    assemblyFile: 'DLLTEST.dll',
    typeName: 'DLLTEST.RecordConsolidatorWrapper',
    methodName: 'ConsolidateRecordAsync'
});

const consolidateVersion = async () => {
    // Get the current time when starting
    const startTime = new Date();
    
    try {
        console.log('Start Time:', startTime.toISOString());
    
        ConsolidateRecordAsync({}, (error: any, result: any) => {
            if (error) {
                console.error('Error:', error);
            } else {
                console.log('Record Consolidator Version:', result);
            }
            return {
                consolidateVersionResult: result
            };
        });
    } catch (error) {
        console.log('Error in JS:', error);
    }
}

export default consolidateVersion;