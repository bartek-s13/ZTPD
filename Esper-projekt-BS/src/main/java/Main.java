import com.espertech.esper.common.client.EPCompiled;
import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompileException;
import com.espertech.esper.compiler.client.EPCompilerProvider;
import com.espertech.esper.runtime.client.*;

import java.io.IOException;


public class Main {
    public static void main(String[] args) throws IOException {
        Configuration configuration = new Configuration();
        configuration.getCommon().addEventType(KursAkcji.class);
        EPRuntime epRuntime = EPRuntimeProvider.getDefaultRuntime(configuration);
       /*
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream spolka as X, kursOtwarcia as Y " +
                        "from KursAkcji.win:length(3) ");
        */

/*        //24 Odp. Ponieważ w oknie są też inne spółki, których nie widać w rezultacie zapytania
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream spolka as X, kursOtwarcia as Y " +
                        "from KursAkcji.win:length(3) " +
                        "where spolka='Oracle'");*/

/*        //25
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream data, spolka, kursOtwarcia " +
                        "from KursAkcji.win:length(3) " +
                        "where spolka='Oracle'");*/

 /*     //26
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream data, spolka, kursOtwarcia " +
                        "from KursAkcji(spolka='Oracle').win:length(3) ");*/


/*     //27
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia " +
                        "from KursAkcji(spolka='Oracle').win:length(3) ");*/
/*     //28
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, max(kursOtwarcia) " +
                        "from KursAkcji(spolka='Oracle').win:length(5) ");*/

/*        //29
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia - max(kursOtwarcia) as roznica" +
                        " from KursAkcji(spolka='Oracle').win:length(5) ");*/

        //30
/*        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia - min(kursOtwarcia)  as roznica" +
                        " from KursAkcji(spolka='Oracle').win:length(2) " +
                        " having(kursOtwarcia - min(kursOtwarcia) > 0)");*/


        //Esper–EPL
        //5
/*        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursZamkniecia, max(kursZamkniecia) - kursZamkniecia as roznica " +
                        " from KursAkcji.win:ext_timed_batch(data.getTime(), 1 days)");*/

        //6
       /* EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursZamkniecia, max(kursZamkniecia) - kursZamkniecia as roznica " +
                        " from KursAkcji(spolka in ('IBM', 'Honda', 'Microsoft')).win:ext_timed_batch(data.getTime(), 1 days)");
*/
        //7a
 /*       EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia, kursZamkniecia " +
                        " from KursAkcji(kursOtwarcia < kursZamkniecia).std:unique(spolka)");
*/
        //7b
        /*EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia, kursZamkniecia " +
                        " from KursAkcji(KursAkcji.roznicaKursow(kursOtwarcia,kursZamkniecia)>0).std:unique(spolka)");
*/
        //8
/*        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursZamkniecia, max(kursZamkniecia) - kursZamkniecia as roznica " +
                        " from KursAkcji(spolka in ('PepsiCo', 'CocaCola')).win:ext_timed(data.getTime(), 7 days)");*/

        //9
       /* EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursZamkniecia" +
                        " from KursAkcji(spolka in ('PepsiCo', 'CocaCola')).win:ext_timed_batch(data.getTime(), 1 days)" +
                        " having kursZamkniecia = max(kursZamkniecia)");*/
        //10
/*        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select max(kursZamkniecia)" +
                        " from KursAkcji.win:ext_timed_batch(data.getTime(), 7 days)"
        );*/

        //11 ???
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream kursPep.kursZamkniecia as kursPep, kursPep.data as data, kursCoc.kursZamkniecia as kursCoc" +
                        " from KursAkcji(spolka='PepsiCo').win:ext_timed(data.getTime(), 1 days) as kursPep, " +
                        " KursAkcji(spolka='CocaCola').win:ext_timed(data.getTime(), 1 days) as kursCoc " +
                        " where kursPep.kursZamkniecia > kursCoc.kursZamkniecia");

        //12





        ProstyListener prostyListener = new ProstyListener();

        for (EPStatement statement : deployment.getStatements()) {
            statement.addListener(prostyListener);
        }
        InputStream inputStream = new InputStream();
        inputStream.generuj(epRuntime.getEventService());
    }

    public static EPDeployment compileAndDeploy(EPRuntime epRuntime, String epl) {
        EPDeploymentService deploymentService = epRuntime.getDeploymentService();
        CompilerArguments args = new CompilerArguments(epRuntime.getConfigurationDeepCopy());
        EPDeployment deployment;
        try {
            EPCompiled epCompiled = EPCompilerProvider.getCompiler().compile(epl, args);
            deployment = deploymentService.deploy(epCompiled);
        } catch (EPCompileException e) {
            throw new RuntimeException(e);
        } catch (EPDeployException e) {
            throw new RuntimeException(e);
        }
        return deployment;
    }
}