package pex.grongier.gs1utils;

import com.intersystems.enslib.pex.*;
import com.intersystems.jdbc.IRISObject;

import se.injoin.gs1utils.GTIN;


public class Operation extends BusinessOperation {


    public void OnInit() throws Exception {

        LOGINFO("Hello World");

        return;
    }

    public void OnTearDown() throws Exception {

        return;
    }

    public Object OnMessage(Object request) throws Exception {

        IRISObject req = (IRISObject) request;
        LOGINFO("Received object: " + req.invokeString("%ClassName", 1));
        String value = req.getString("StringValue");
        LOGINFO("StringValue: " + value);

        MyMessage response = new MyMessage();

        try {
            boolean isGTIN = GTIN.isGTIN(value);

            response.isGTIN = isGTIN;

            response.value = "Hello";

        } catch (Exception e) {
            LOGINFO("StringValue: " +e.getMessage());
        }

        return response;
    }

}
