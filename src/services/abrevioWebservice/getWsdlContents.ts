import path from "path";
import fs from 'fs';

const wsdlPath = path.join(__dirname, 'abrevioWebservice.wsdl');
const wsdlContents = fs.readFileSync(wsdlPath, 'utf8');

export default wsdlContents;