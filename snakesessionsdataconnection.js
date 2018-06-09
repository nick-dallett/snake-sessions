const sql = require("mysql");
const snakesessions_hostname = "snakesessions.cxum5fxcbsvj.us-west-2.rds.amazonaws.com";
const snakesessions_username = "snakesessions";
const snakesessions_password = "snakesessions";
const snakesessions_database = "SnakeSessions";

/*************************************************/
/*********** Database Connection Class ***********/
/*************************************************/

module.exports = class SnakeSessionsDataConnection{
    constructor(){
        this.m_connection = sql.createConnection({
            host: snakesessions_hostname,
            user: snakesessions_username,
            password: snakesessions_password,
            database: snakesessions_database,
            typeCast: true
          });
    }

    Connect(){
        return new Promise((resolve, reject) => {
            this.m_connection.connect((err) => {
                (err) ? reject(err) : resolve();
              });
        })
    }

    Query(qstring){
        return new Promise((resolve, reject) => {
            this.m_connection.query(qstring, (err, query_result) => {
                (err) ? reject(err) : resolve(query_result);
            });
        });
    }

    Close(){
        this.m_connection.end();
    }

}