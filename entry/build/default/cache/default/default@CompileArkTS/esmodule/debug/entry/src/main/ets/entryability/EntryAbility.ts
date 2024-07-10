import UIAbility from "@ohos:app.ability.UIAbility";
import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import type Want from "@ohos:app.ability.Want";
import type window from "@ohos:window";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import { columnDayInfoList, columnGlobalInfoList, columnTaskInfoInfoList, columnFormInfoList } from "@bundle:com.example.healthy_life/entry/ets/model/RdbColumnModel";
import RdbUtils from "@bundle:com.example.healthy_life/entry/ets/common/database/rdb/RdbUtils";
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
import FormUtils from "@bundle:com.example.healthy_life/entry/ets/common/utils/FormUtils";
import { GlobalContext } from "@bundle:com.example.healthy_life/entry/ets/common/utils/GlobalContext";
export default class EntryAbility extends UIAbility {
    private static TAG: string = 'EntryAbility';
    async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
        GlobalContext.getContext().setObject('want', want);
        GlobalContext.getContext().setObject('launchParam', launchParam);
        RdbUtils.initDb(this.context, Const.RDB_NAME.dbName ? Const.RDB_NAME.dbName : '');
        await RdbUtils.createDb();
        RdbUtils.createTable(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '', columnDayInfoList).then(() => {
            Logger.info(`RdbHelper createTable dayInfo success`);
        }).catch((err: Error) => {
            Logger.error(`RdbHelper dayInfo err : ${JSON.stringify(err)}`);
        });
        RdbUtils.createTable(Const.GLOBAL_INFO.tableName ? Const.GLOBAL_INFO.tableName : '', columnGlobalInfoList)
            .then(() => {
            Logger.info(`RdbHelper createTable globalInfo success`);
        })
            .catch((err: Error) => {
            Logger.error(`RdbHelper globalInfo err : ${JSON.stringify(err)}`);
        });
        RdbUtils.createTable(Const.TASK_INFO.tableName ? Const.TASK_INFO.tableName : '', columnTaskInfoInfoList)
            .then(() => {
            Logger.info(`RdbHelper createTable taskInfo success`);
        })
            .catch((err: Error) => {
            Logger.error(`RdbHelper taskInfo err : ${JSON.stringify(err)}`);
        });
        RdbUtils.createTable(Const.FORM_INFO.tableName ? Const.FORM_INFO.tableName : '', columnFormInfoList)
            .catch((err: Error) => {
            Logger.error(`RdbHelper formInfo err : ${JSON.stringify(err)}`);
        });
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        GlobalContext.getContext().setObject('isForeground', true);
        windowStage.loadContent('pages/SplashPage', (err, data) => {
            if (err.code) {
                Logger.error('windowStage', 'Failed to load the content. Cause:' + JSON.stringify(err));
                return;
            }
            Logger.info('windowStage', 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
        });
    }
    onForeground() {
        // Ability has brought to foreground
        GlobalContext.getContext().setObject('isForeground', true);
        GlobalContext.getContext().setObject('taskListChange', false);
    }
    onBackground() {
        // Ability has back to background
        FormUtils.backgroundUpdateCard(GlobalContext.getContext().getObject('taskListChange') as boolean);
    }
    onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
        // Ability has new want
        GlobalContext.getContext().setObject('abilityWant', want);
        GlobalContext.getContext().setObject('launchParam', launchParam);
    }
}
;
