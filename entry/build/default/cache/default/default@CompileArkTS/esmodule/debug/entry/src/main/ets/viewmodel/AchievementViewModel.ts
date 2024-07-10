import CardInfo from "@bundle:com.example.healthy_life/entry/ets/viewmodel/CardInfo";
import { ACHIEVEMENT_LEVEL_LIST, AchievementMap } from "@bundle:com.example.healthy_life/entry/ets/model/TaskInitList";
export function getBadgeCardItems(successiveDays: number): Array<CardInfo> {
    let badgeMileStones = ACHIEVEMENT_LEVEL_LIST;
    let cardItems: Array<CardInfo> = [];
    for (let i = 0; i < badgeMileStones.length; i++) {
        let onOrOff = successiveDays >= badgeMileStones[i] ? 'on' : 'off';
        let titleContent = String(badgeMileStones[i]);
        let cardInfo: CardInfo = new CardInfo();
        cardInfo.titleContent = titleContent;
        cardInfo.achievement = getAchievement(`${onOrOff}_${badgeMileStones[i]}`);
        cardItems.push(cardInfo);
    }
    return cardItems;
}
function getAchievement(key: string) {
    let result = { "id": 16777237, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
    switch (key) {
        case 'off_3':
            result = AchievementMap.off_3;
            break;
        case 'on_3':
            result = AchievementMap.on_3;
            break;
        case 'off_7':
            result = AchievementMap.off_7;
            break;
        case 'on_7':
            result = AchievementMap.on_7;
            break;
        case 'off_30':
            result = AchievementMap.off_30;
            break;
        case 'on_30':
            result = AchievementMap.on_30;
            break;
        case 'off_50':
            result = AchievementMap.off_50;
            break;
        case 'on_50':
            result = AchievementMap.on_50;
            break;
        case 'off_73':
            result = AchievementMap.off_73;
            break;
        case 'on_73':
            result = AchievementMap.on_73;
            break;
        case 'off_99':
            result = AchievementMap.off_99;
            break;
        case 'on_99':
            result = AchievementMap.on_99;
            break;
        default:
            break;
    }
    return result;
}
