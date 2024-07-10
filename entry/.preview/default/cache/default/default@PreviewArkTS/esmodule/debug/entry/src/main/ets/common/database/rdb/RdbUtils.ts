import relationalStore from "@ohos:data.relationalStore";
import type ColumnInfo from '../../../viewmodel/ColumnInfo';
import type { RdbHelper } from './RdbHelper';
import { RdbHelperImp } from "@bundle:com.example.healthy_life/entry/ets/common/database/rdb/RdbHelperImp";
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
let dbContext: Context;
let mDatabaseName: string = '';
export class RdbUtils {
    private rdbHelpers = new Map<string, RdbHelper>();
    initDb(context: Context, databaseName: string) {
        dbContext = context;
        mDatabaseName = databaseName;
    }
    createDb(): Promise<RdbHelper> {
        return new Promise<RdbHelper>((success, error) => {
            let dbName = mDatabaseName;
            if (!dbContext || !dbName || dbName.length === 0) {
                error('init err');
                return;
            }
            let dbHelper = this.rdbHelpers.get(dbName);
            if (!dbHelper) {
                Logger.info(`initRdb  RdbUtils success`);
                let rdbHelper: RdbHelper = new RdbHelperImp(dbName);
                rdbHelper.getRdb(dbContext).then(data => {
                    this.rdbHelpers.set(dbName, data);
                    success(data);
                }).catch((err: Error) => {
                    error(err);
                });
            }
            else {
                success(dbHelper);
            }
        });
    }
    deleteDb(context: Context, dbName: string): Promise<void> {
        this.rdbHelpers.delete(dbName);
        return relationalStore.deleteRdbStore(context, dbName);
    }
    createTable(tableName: string, columns: Array<ColumnInfo>): Promise<void> {
        return this.createDb().then(dbHelper => {
            return dbHelper.createTable(tableName, columns);
        });
    }
    isCreateTable(tableName: string, columns: Array<ColumnInfo>): Promise<boolean> {
        return this.createTable(tableName, columns).then(() => {
            return true;
        }).catch((error: Error) => {
            Logger.error('RdbUtils', 'create table error ' + JSON.stringify(error));
            return false;
        });
    }
    deleteTable(tableName: string): Promise<void> {
        return this.createDb().then(dbHelper => {
            return dbHelper.deleteTable(tableName);
        });
    }
    executeSql(sql: string): Promise<void> {
        return this.createDb().then(dbHelper => {
            return dbHelper.executeSql(sql);
        });
    }
    addTableColumn(tableName: string, column: ColumnInfo): Promise<void> {
        return this.createDb().then(dbHelper => {
            return dbHelper.addTableColumn(tableName, column);
        });
    }
    insert(tableName: string, values: relationalStore.ValuesBucket | Array<relationalStore.ValuesBucket>): Promise<number> {
        return this.createDb().then(dbHelper => {
            return dbHelper.insert(tableName, values);
        });
    }
    update(values: relationalStore.ValuesBucket, rdbPredicates: relationalStore.RdbPredicates): Promise<number> {
        return this.createDb().then(dbHelper => {
            return dbHelper.update(values, rdbPredicates);
        });
    }
    query(rdbPredicates: relationalStore.RdbPredicates, columns?: Array<string>): Promise<relationalStore.ResultSet> {
        return this.createDb().then(dbHelper => {
            return dbHelper.query(rdbPredicates, columns);
        });
    }
    queryAll(tableName: string): Promise<relationalStore.ResultSet> {
        return this.createDb().then(dbHelper => {
            return dbHelper.queryAll(tableName);
        });
    }
    queryBySql(sql: string, bindArgs?: Array<relationalStore.ValueType>): Promise<relationalStore.ResultSet> {
        return this.createDb().then(dbHelper => {
            return dbHelper.queryBySql(sql, bindArgs);
        });
    }
    del(rdbPredicates: relationalStore.RdbPredicates): Promise<number> {
        return this.createDb().then(dbHelper => {
            return dbHelper.delete(rdbPredicates);
        });
    }
}
let rdbUtils = new RdbUtils();
export default rdbUtils as RdbUtils;
