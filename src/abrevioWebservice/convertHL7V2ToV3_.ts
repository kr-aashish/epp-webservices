// const edge = require('edge-js');
import edge from 'edge-js';

// Load the .NET assembly function
const convertHL7V2ToV3Async = edge.func({
    assemblyFile: 'DLLTEST.dll',
    typeName: 'DLLTEST.DLLTEST',
    methodName: 'ConvertHL7V2ToV3Async'
});

// Sample HL7v2 message
const hl7v2 = `MSH|^~\&|E-Path|Indianapolis Regional Hospital^14D0432237^CLIA|E-Path Plus|OSF|20220707||ORU^R01^ORU^R01|OSF230202105846228|P|2.5.1|||||USA||ENG||2.2
PID|1||N999707^^^=Indianapolis Regional Hospital&14D0432237&CLIA^MR~313-02-9999^^^^SS||Parenteau^Christelle^||19380611|F||2106-3^White^CDCREC^2106-3^WHITE^Local|3406 Elk City Road^^Indianapolis^IN^46214^US^^^|||||S||||||2186-5^Not Hispanic or Latino^CDCREC^NOT HISPANIC OR LATINO^Local|||||||||||||||||
PV1|1||||||^Berteau^Zachary^^^^^^^^^^NPI|^Leigh^Ariel^^^^^^^^^^NPI||||||||||||||||||||||||||||||||||||||||||||
ORC|RE||||||||||||||||||||Elk City Neurological Center|9203 Cedar Road^^Indianapolis^IN^46214^^^^||^^^^^^|||||||
OBR|1||SU-22-2130|11529-5^Surgical Pathology Report^LN|||20220907|||||||||^Leigh^Ariel^^^^^^^^^^NPI|||||||||F||||||1^0^^^^^^^^^^^^^^^^1^|||||||||||||||||||
OBX|1|FT|22638-1^SURGICAL INFORMATION^LN||Date of Surgery: 09/07/22\X0D\\X0A\Specimen Received: 09/07/22\X0D\\X0A\Physician: Berteau, Zachary MD\X0D\\X0A\Pathologist: Ghee, Jessie MD\X0D\\X0A\\X0D\\X0A\||||||F|
OBX|2|FT|22634-0^GROSS DESCRIPTION^LN||Specimen\X0D\\X0A\A. Right brain tumor\X0D\\X0A\B. Right brain tumor\X0D\\X0A\\X0D\\X0A\A.  Received fresh for frozen section labeled with the\X0D\\X0A\patient's name and "right brain tumor" is a 1.5 x 0.8 x 0.1 cm\X0D\\X0A\aggregate of yellow-pink to translucent, glistening\X0D\\X0A\gelatinous soft tissue.  Two smears are performed and stained\X0D\\X0A\with diff quik.  The remainder of the specimen is submitted\X0D\\X0A\in entirety in A1.  \X0D\\X0A\\X0D\\X0A\B.  Received fresh labeled with the patient's name and "right\X0D\\X0A\brain tumor" is a 3 x 2.5 x 0.1 cm aggregate of red-to-tan  \X0D\\X0A\clear, unoriented, soft tissue fragments which range from less\X0D\\X0A\than 0.1 cm to 0.5 cm in greatest dimension.  The specimen is\X0D\\X0A\submitted in entirety in B1.  \X0D\\X0A\\X0D\\X0A\Frozen Section Diagnosis\X0D\\X0A\A. Glial neoplasm, favor pilocytic astrocytoma.  \X0D\\X0A\Called into the OR 09/07/22 at 0830 HRS by Dr. Jessie Ghee.  \X0D\\X0A\\X0D\\X0A\||||||F|
OBX|3|FT|22635-7^MICROSCOPIC^LN||A. 2 Diff Quik stains, 1 slide H/E&E/E:\X0D\\X0A\Sections show small fragments of pilocytic astrocytoma,\X0D\\X0A\morphologically similar to that described for specimen B.\X0D\\X0A\\X0D\\X0A\B. 1 slide H/E&E/E, 1 GFAP, 1 SOX-10, 1 MIB1, 1 P53, 1 P16, \X0D\\X0A\ ATRX, 1 Histone X1X11X, 1 BRAF V600E:\X0D\\X0A\Sections show a hypocellular glial neoplasm with a \X0D\\X0A\predominantly loose arrangement of cells with bland oval\X0D\\X0A\nuclei and delicate eosinophilic fibrillar hair-like\X0D\\X0A\processes typical of pilocytic astrocytoma.  Although there\X0D\\X0A\is a fairly extensive myxoid background, the lesional cells\X0D\\X0A\do not show a significant tendency for perivascular\X0D\\X0A\pseudorosette formation.  Scatted eosinophilic granulate\X0D\\X0A\bodies are detected.  Mitotic figures are difficult to find\X0D\\X0A\and there is no significant nuclear pleomorphism, hypercellularity,\X0D\\X0A\microvascular proliferation, or necrosis.  The lesion is strongly\X0D\\X0A\and diffusely positive for GFAP with widespread SOX-10 nuclear\X0D\\X0A\positivity.  MIB1 confirms a low proliferation index, \X0D\\X0A\averaging 1-2%.  There is no significant nuclear positivity for\X0D\\X0A\p53 immunostain, while tumor cell nuclei have retained \X0D\\X0A\expression of both p16 and ATRX.  Mutant-specific \X0D\\X0A\immunohistochemical stain targeting Histone H3 X11X is entirely \X0D\\X0A\negative, while stain for BRAF V600E shows diffuse staining \X0D\\X0A\throughout the lesion.\X0D\\X0A\\X0D\\X0A\This test(s) was developed and its performance characteristics\X0D\\X0A\determined by Neurological Genetic Laboratories.  It has not\X0D\\X0A\been cleared or approved by the Centers for Medicare.  The FDA\X0D\\X0A\has determined that such clearance or approval was not necessary.\X0D\\X0A\This test is used for clinical purposes.  It should not be\X0D\\X0A\regarded as investigational or for research.  This laboratory \X0D\\X0A\is certified under the Clinical Laboratory Improvement Amendments\X0D\\X0A\of 1988 (CLIA) as qualified to perform high complexity clinical\X0D\\X0A\laboratory testing.  \X0D\\X0A\\X0D\\X0A\||||||F|`;

const v2CodeUpdateSetting = null; 

// Number of iterations
const iterations = 10;

// Perform the operation in a loop
for (let i = 0; i < iterations; i++) {
    const params = {
        hl7v2: hl7v2,
        v2CodeUpdateSetting: v2CodeUpdateSetting
    };

    const startTime = process.hrtime();
    convertHL7V2ToV3Async(params, (error: any, result: any) => {
        if (error) {
            console.error('Error:', error);
        } else {
            const elapsedTime = process.hrtime(startTime);
            const seconds = elapsedTime[0];
            const nanoseconds = elapsedTime[1];
            const milliseconds = (seconds * 1000) + (nanoseconds / 1e6);
            console.log(`Iteration ${i + 1} completed in ${milliseconds} ms`);
            //console.log('Result:', result);
        }
    });
}
