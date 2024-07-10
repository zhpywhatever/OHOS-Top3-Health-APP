import { oneWeekDictFunc } from "@bundle:com.example.healthy_life/entry/ets/common/utils/Utils";
/**
 * TaskInfo
 *
 * @param id
 * @param date
 * @param taskID
 * @param targetValue
 * @param isAlarm
 * @param startTime
 * @param endTime
 * @param frequency
 * @param isDone
 * @param doneValue
 * @param isOpen
 */
export default class TaskInfo {
    id: number;
    date: string;
    taskID: number;
    targetValue: string;
    isAlarm: boolean;
    startTime: string;
    endTime: string;
    frequency: string;
    isDone: boolean;
    finValue: string;
    isOpen: boolean;
    constructor(id: number, date: string, taskID: number, targetValue: string, isAlarm: boolean, startTime: string, endTime: string, frequency: string, isDone: boolean, finValue: string, isOpen = false) {
        this.id = id;
        this.date = date;
        this.taskID = taskID;
        this.targetValue = targetValue;
        this.isAlarm = isAlarm;
        this.startTime = startTime;
        this.endTime = endTime;
        this.frequency = frequency;
        this.isDone = isDone;
        this.finValue = finValue;
        this.isOpen = isOpen;
    }
}
export enum taskType {
    'getup' = 1,
    'drinkWater' = 2,
    'eatApple' = 3,
    'smile' = 4,
    'brushTeeth' = 5,
    'sleepEarly' = 6
}
export const oneWeek = oneWeekDictFunc();
