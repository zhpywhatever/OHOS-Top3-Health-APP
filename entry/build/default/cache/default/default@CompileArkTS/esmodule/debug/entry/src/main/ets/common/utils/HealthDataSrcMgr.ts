import { BroadCast } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
const APP_KEY_GROUP_DATA_SOURCE_MANAGER = 'app_key_group_data_source_manager';
export class HealthDataSrcMgr {
    private broadCast: BroadCast;
    constructor() {
        Logger.debug('HealthDataSourceManager', 'constructor');
        this.broadCast = new BroadCast();
    }
    public static getInstance(): HealthDataSrcMgr {
        if (!AppStorage.get<HealthDataSrcMgr>(APP_KEY_GROUP_DATA_SOURCE_MANAGER)) {
            AppStorage.setOrCreate<HealthDataSrcMgr>(APP_KEY_GROUP_DATA_SOURCE_MANAGER, new HealthDataSrcMgr());
        }
        let healthDataSrcMgr = AppStorage.get<HealthDataSrcMgr>(APP_KEY_GROUP_DATA_SOURCE_MANAGER);
        return healthDataSrcMgr ? healthDataSrcMgr : new HealthDataSrcMgr();
    }
    public getBroadCast(): BroadCast {
        return this.broadCast;
    }
}
