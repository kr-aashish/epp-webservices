import initialiseExpressApp from './expressApp';
import startServer from './server';

(async () => {
    const app = await initialiseExpressApp();
    await startServer(app);
})();
