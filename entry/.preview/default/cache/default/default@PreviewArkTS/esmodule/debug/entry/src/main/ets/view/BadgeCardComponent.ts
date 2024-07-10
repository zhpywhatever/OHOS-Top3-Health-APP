if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface BadgeCard_Params {
    content?: string;
    imgSrc?: Resource;
}
import { ratio2percent } from "@bundle:com.example.healthy_life/entry/ets/common/utils/Utils";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
export class BadgeCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__content = new SynchedPropertySimpleOneWayPU(params.content, this, "content");
        this.imgSrc = { "id": 16777238, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: BadgeCard_Params) {
        if (params.content === undefined) {
            this.__content.set('');
        }
        if (params.imgSrc !== undefined) {
            this.imgSrc = params.imgSrc;
        }
    }
    updateStateVars(params: BadgeCard_Params) {
        this.__content.reset(params.content);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__content.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__content.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __content: SynchedPropertySimpleOneWayPU<string>;
    get content() {
        return this.__content.get();
    }
    set content(newValue: string) {
        this.__content.set(newValue);
    }
    private imgSrc: Resource;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: Const.DEFAULT_18 });
            Column.debugLine("entry/src/main/ets/view/BadgeCardComponent.ets(25:5)");
            Column.width(ratio2percent(Const.ACHIEVE_SPLIT_RATIO));
            Column.padding({ top: Const.ACHIEVE_CARD_TOP, bottom: Const.ACHIEVE_CARD_BOTTOM });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.imgSrc);
            Image.debugLine("entry/src/main/ets/view/BadgeCardComponent.ets(26:7)");
            Image.width(Const.FULL_WIDTH);
            Image.height(Const.ACHIEVE_CARD_IMG_HEIGHT);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777258, "type": 10003, params: [Number(this.content)], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/view/BadgeCardComponent.ets(30:7)");
            Text.lineHeight({ "id": 16777296, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontSize({ "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor({ "id": 16777386, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Text);
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
