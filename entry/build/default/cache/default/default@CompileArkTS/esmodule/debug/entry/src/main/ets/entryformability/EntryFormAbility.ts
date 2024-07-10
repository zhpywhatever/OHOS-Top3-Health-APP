import FormExtensionAbility from "@ohos:app.form.FormExtensionAbility";
import formBindingData from "@ohos:app.form.formBindingData";
import type Want from "@ohos:app.ability.Want";
import type FormInfo from '../viewmodel/FormInfo';
import FormUtils from "@bundle:com.example.healthy_life/entry/ets/common/utils/FormUtils";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
export default class EntryFormAbility extends FormExtensionAbility {
    onAddForm(want: Want) {
        let parameters = want.parameters;
        if (parameters) {
            let formId: string = parameters[Const.FORM_PARAM_IDENTITY_KEY] as string;
            let formName: string = parameters[Const.FORM_PARAM_NAME_KEY] as string;
            let formDimension: number = parameters[Const.FORM_PARAM_DIMENSION_KEY] as number;
            let formInfo: FormInfo = {
                formId: formId,
                formName: formName,
                formDimension: formDimension
            };
            FormUtils.insertFormData(this.context, formInfo);
        }
        // Called to return a FormBindingData object.
        let formData = formBindingData.createFormBindingData('');
        return formData;
    }
    onUpdateForm() {
        FormUtils.updateCards(this.context);
    }
    onRemoveForm(formId: string) {
        FormUtils.deleteFormData(this.context, formId);
    }
}
