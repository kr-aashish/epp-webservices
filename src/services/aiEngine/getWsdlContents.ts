import path from "path";
import fs from 'fs';

const wsdlPath = path.join(__dirname, 'aiEngine.wsdl');
const wsdlContents = fs.readFileSync(wsdlPath, 'utf8');

export default wsdlContents;