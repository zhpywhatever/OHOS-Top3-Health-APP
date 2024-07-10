import type AgencyCardInfo from './AgencyCardInfo';
/**
 * Progress card task info
 */
export default class ProgressCardInfo {
    /**
     * Task list
     */
    taskList?: AgencyCardInfo[];
    /**
     * Target completion quantity
     */
    numerator?: number;
    /**
     * Total Targets
     */
    denominator?: number;
    /**
     * Completion progress
     */
    percent?: string;
    /**
     * Whether to display widgets
     */
    showWidget?: boolean;
}
