if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AddBtn_Params {
    clickAction?: Function;
}
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
export default class AddBtn extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.clickAction = () => {
        };
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AddBtn_Params) {
        if (params.clickAction !== undefined) {
            this.clickAction = params.clickAction;
        }
    }
    updateStateVars(params: AddBtn_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private clickAction: Function;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild({ type: ButtonType.Circle, stateEffect: false });
            Button.onClick(() => this.clickAction());
            Button.zIndex(Const.HOME_BTN_Z);
            Button.position({ x: Const.THOUSANDTH_830, y: Const.THOUSANDTH_880 });
            Button.width({ "id": 16777323, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Button.height({ "id": 16777323, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777373, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.width(Const.THOUSANDTH_1000);
            Image.height(Const.THOUSANDTH_1000);
            Image.borderRadius(Const.BORDER_RADIUS_PERCENT_50);
        }, Image);
        Button.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
