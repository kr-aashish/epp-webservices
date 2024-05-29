export interface ConvertHL7V2TOV3Args {
    hl7v2: string;
}

export interface ConvertHL7V2TOV3Result {
    covertHL7V2TOV3Result: string;
    version: string;
    hl7v3?: string;
    error?: string;
}