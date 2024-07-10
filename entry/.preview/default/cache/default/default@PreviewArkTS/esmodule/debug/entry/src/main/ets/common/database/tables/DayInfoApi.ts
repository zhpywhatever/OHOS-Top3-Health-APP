import relationalStore from "@ohos:data.relationalStore";
import DayInfo from "@bundle:com.example.healthy_life/entry/ets/viewmodel/DayInfo";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import RdbUtils from "@bundle:com.example.healthy_life/entry/ets/common/database/rdb/RdbUtils";
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
class DayInfoApi {
    /**
     * Insert dayInfo.
     *
     * @param dayInfo
     * @param callback
     */
    insertData(dayInfo: DayInfo, callback: Function): void {
        const valueBucket = generateBucket(dayInfo);
        RdbUtils.insert('dayInfo', valueBucket).then(result => {
            callback(result);
        });
        Logger.info('DayInfoTable', 'Insert dayInfo finished.');
    }
    /**
     * Update dayInfo.
     *
     * @param dayInfo
     * @param callback
     */
    updateData(dayInfo: DayInfo, callback: Function): void {
        const valueBucket = generateBucket(dayInfo);
        let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '');
        predicates.equalTo('date', dayInfo.date);
        RdbUtils.update(valueBucket, predicates).then((result: number) => {
            callback(result);
        });
        Logger.info('DayInfoTable', 'Update dayInfo finished.');
    }
    /**
     * Query dayInfo.
     *
     * @param date
     * @param callback
     */
    query(date: string, callback: Function): void {
        let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '');
        predicates.equalTo('date', date);
        RdbUtils.query(predicates).then(resultSet => {
            let count = resultSet.rowCount;
            if (count === 0) {
                Logger.info('DayInfoTable', 'query no results.');
                let result = new DayInfo('', 0, 0);
                callback(result);
            }
            else {
                let result = new DayInfo('', 0, 0);
                resultSet.goToFirstRow();
                result.date = resultSet.getString(resultSet.getColumnIndex('date'));
                result.targetTaskNum = resultSet.getDouble(resultSet.getColumnIndex('targetTaskNum'));
                result.finTaskNum = resultSet.getDouble(resultSet.getColumnIndex('finTaskNum'));
                callback(result);
            }
            return;
        });
    }
    /**
     * Query dayInfo list.
     *
     * @param date
     * @param callback
     */
    queryList(dates: string[], callback: Function): void {
        let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '');
        predicates.in('date', dates);
        RdbUtils.query(predicates).then(resultSet => {
            let count = resultSet.rowCount;
            if (count === 0) {
                Logger.info('DayInfoTable', 'query no results.');
                let result: DayInfo[] = [];
                callback(result);
            }
            else {
                resultSet.goToFirstRow();
                let result: DayInfo[] = [];
                for (let i = 0; i < count; i++) {
                    let tmp = new DayInfo('', 0, 0);
                    tmp.date = resultSet.getString(resultSet.getColumnIndex('date'));
                    tmp.targetTaskNum = resultSet.getDouble(resultSet.getColumnIndex('targetTaskNum'));
                    tmp.finTaskNum = resultSet.getDouble(resultSet.getColumnIndex('finTaskNum'));
                    result[i] = tmp;
                    resultSet.goToNextRow();
                }
                callback(result);
            }
        });
    }
}
function generateBucket(dayInfo: DayInfo): relationalStore.ValuesBucket {
    let valueBucket = {} as relationalStore.ValuesBucket;
    Const.DAY_INFO.columns?.forEach((item: string) => {
        switch (item) {
            case 'date':
                valueBucket.date = dayInfo.date;
                break;
            case 'targetTaskNum':
                valueBucket.targetTaskNum = dayInfo.targetTaskNum;
                break;
            case 'finTaskNum':
                valueBucket.finTaskNum = dayInfo.finTaskNum;
                break;
            default:
                break;
        }
    });
    return valueBucket;
}
let dayInfoApi = new DayInfoApi();
export default dayInfoApi as DayInfoApi;
