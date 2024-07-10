if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface BadgePanel_Params {
    successiveDays?: number;
}
import { BadgeCard } from "@bundle:com.example.healthy_life/entry/ets/view/BadgeCardComponent";
import { getAchievementLevel } from "@bundle:com.example.healthy_life/entry/ets/model/AchieveModel";
import { getBadgeCardItems } from "@bundle:com.example.healthy_life/entry/ets/viewmodel/AchievementViewModel";
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
import { ACHIEVEMENT_LEVEL_KEY } from "@bundle:com.example.healthy_life/entry/ets/model/AchieveModel";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import type CardInfo from '../viewmodel/CardInfo';
export class BadgePanel extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__successiveDays = this.createStorageProp(ACHIEVEMENT_LEVEL_KEY, 0, "successiveDays");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: BadgePanel_Params) {
    }
    updateStateVars(params: BadgePanel_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__successiveDays.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__successiveDays.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __successiveDays: ObservedPropertyAbstractPU<number>;
    get successiveDays() {
        return this.__successiveDays.get();
    }
    set successiveDays(newValue: number) {
        this.__successiveDays.set(newValue);
    }
    aboutToAppear() {
        Logger.debug('BadgePanel', 'aboutToAppear');
        getAchievementLevel();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap });
            Flex.width(Const.FULL_WIDTH);
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new BadgeCard(this, { content: item.titleContent, imgSrc: item.achievement }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/BadgePanelComponent.ets", line: 36 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    content: item.titleContent,
                                    imgSrc: item.achievement
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                content: item.titleContent
                            });
                        }
                    }, { name: "BadgeCard" });
                }
            };
            this.forEachUpdateFunction(elmtId, getBadgeCardItems(this.successiveDays), forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        Flex.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
