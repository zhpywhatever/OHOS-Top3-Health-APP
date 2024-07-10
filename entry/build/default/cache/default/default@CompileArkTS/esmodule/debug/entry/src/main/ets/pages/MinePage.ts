if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineIndex_Params {
    nickname?: string;
    signature?: string;
}
import { ListInfo } from "@bundle:com.example.healthy_life/entry/ets/view/ListInfo";
import { UserBaseInfo } from "@bundle:com.example.healthy_life/entry/ets/view/UserBaseInfo";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
export class MineIndex extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__nickname = new ObservedPropertySimplePU(Const.NICK_NAME, this, "nickname");
        this.__signature = new ObservedPropertySimplePU(Const.SIGNATURE, this, "signature");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineIndex_Params) {
        if (params.nickname !== undefined) {
            this.nickname = params.nickname;
        }
        if (params.signature !== undefined) {
            this.signature = params.signature;
        }
    }
    updateStateVars(params: MineIndex_Params) {
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
    private __nickname: ObservedPropertySimplePU<string>;
    get nickname() {
        return this.__nickname.get();
    }
    set nickname(newValue: string) {
        this.__nickname.set(newValue);
    }
    private __signature: ObservedPropertySimplePU<string>;
    get signature() {
        return this.__signature.get();
    }
    set signature(newValue: string) {
        this.__signature.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(Const.FULL_HEIGHT);
            Column.backgroundColor({ "id": 16777278, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new UserBaseInfo(this, {
                        nickname: this.nickname,
                        signature: this.signature
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/MinePage.ets", line: 27 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            nickname: this.nickname,
                            signature: this.signature
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        nickname: this.nickname,
                        signature: this.signature
                    });
                }
            }, { name: "UserBaseInfo" });
        }
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new ListInfo(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/MinePage.ets", line: 32 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "ListInfo" });
        }
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
