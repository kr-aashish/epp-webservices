import { Request, Response } from 'express';
import path from "path";
import fs from 'fs';

const abrevioWebservice = async (req: Request, res: Response): Promise<void> => {
    const wsdlPath = path.join(__dirname, 'abrevioWebservice.html');
    const wsdlContents = fs.readFileSync(wsdlPath, 'utf8');

    res.set('Content-Type', 'text/html');
    res.send(wsdlContents);
};

export default abrevioWebservice;
