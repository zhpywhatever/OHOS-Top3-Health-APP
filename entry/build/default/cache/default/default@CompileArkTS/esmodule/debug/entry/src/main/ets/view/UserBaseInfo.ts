if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface UserBaseInfo_Params {
    nickname?: string;
    signature?: string;
}
export class UserBaseInfo extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__nickname = new SynchedPropertySimpleOneWayPU(params.nickname, this, "nickname");
        this.__signature = new SynchedPropertySimpleOneWayPU(params.signature, this, "signature");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: UserBaseInfo_Params) {
        if (params.nickname === undefined) {
            this.__nickname.set('Top3');
        }
        if (params.signature === undefined) {
            this.__signature.set('遥遥领先遥遥领先');
        }
    }
    updateStateVars(params: UserBaseInfo_Params) {
        this.__nickname.reset(params.nickname);
        this.__signature.reset(params.signature);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__nickname.purgeDependencyOnElmtId(rmElmtId);
        this.__signature.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__nickname.aboutToBeDeleted();
        this.__signature.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __nickname: SynchedPropertySimpleOneWayPU<string>;
    get nickname() {
        return this.__nickname.get();
    }
    set nickname(newValue: string) {
        this.__nickname.set(newValue);
    }
    private __signature: SynchedPropertySimpleOneWayPU<string>;
    get signature() {
        return this.__signature.get();
    }
    set signature(newValue: string) {
        this.__signature.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // userIcon
            Stack.create();
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777394, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.objectFit(ImageFit.Contain);
            Image.height({ "id": 16777328, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.width({ "id": 16777328, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.margin({ top: { "id": 16777330, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            //.border({width: 3, color: Color.Blue})
            Image.create({ "id": 16777405, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            //.border({width: 3, color: Color.Blue})
            Image.height({ "id": 16777302, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            //.border({width: 3, color: Color.Blue})
            Image.width({ "id": 16777302, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            //.border({width: 3, color: Color.Blue})
            Image.margin({ top: { "id": 16777330, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
        }, Image);
        // userIcon
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width({ "id": 16777321, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Column.height({ "id": 16777307, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Column.margin({ top: { "id": 16777333, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
            Column.border({ radius: { "id": 16777324, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
            Column.backgroundColor({ "id": 16777275, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Column.justifyContent(FlexAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('LV.7');
            Text.fontSize({ "id": 16777303, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bolder);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // nickname
            Text.create(this.nickname);
            // nickname
            Text.fontSize({ "id": 16777309, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            // nickname
            Text.fontFamily({ "id": 16777225, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            // nickname
            Text.margin({ bottom: { "id": 16777326, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
            // nickname
            Text.fontWeight(FontWeight.Normal);
            // nickname
            Text.fontColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Text);
        // nickname
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // signature
            Text.create(this.signature);
            // signature
            Text.fontSize({ "id": 16777307, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            // signature
            Text.fontWeight(FontWeight.Normal);
            // signature
            Text.fontFamily({ "id": 16777226, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            // signature
            Text.fontColor({ "id": 16777285, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Text);
        // signature
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
