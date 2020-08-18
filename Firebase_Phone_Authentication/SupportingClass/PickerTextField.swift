

import UIKit
/**
 PickerTextField
 
 Picker text field handles picking data from picker view.It's input view is UIPickerView instead of Keypad.
 
 - Author:
 Inderjeet Singh
 
 - Copyright:
 Zapbuild Technologies Pvt Ltd
 
 - Date:
 14/01/20.
 
 - Version:
 1.0.0
 */
@IBDesignable
public class PickerTextField: SkyFloatingLabelTextFieldWithIcon {
  
    //MARK:- Properties
    open weak var pickerTextFieldDelegate: PickerTextFieldDelegate?// delegate should be assigned from parent view controller
    open var selectedIndex: Int?// Current selecte row index
    private var pickerView: UIPickerView?// picker view of current text field
    private var shouldShowBlankRow: Bool = false// To set blank row
    private var data: [String]?// Pass data for showing in picker

    override public func awakeFromNib() {
        super.awakeFromNib()
        inputView = pickerView
        delegate = self
    }
    
    
    //MARK:- Private Methods
    /**
     For Preparing required UI and common initilization. It must be called in init methods.
     */
  
    
    /**
     Selecting data and index after user intraction with picker view
     */
    private func setSelectedData() {
      selectedIndex = pickerView?.selectedRow(inComponent: 0)
        var textFieldValue: String?
        if let selectedIndex = selectedIndex {
            if shouldShowBlankRow && selectedIndex == 0 {
                self.selectedIndex = nil
            } else if shouldShowBlankRow {
                self.selectedIndex = selectedIndex - 1
                textFieldValue = data?[selectedIndex]
            } else if (data?.count ?? 0) > selectedIndex {
                self.selectedIndex = selectedIndex
                textFieldValue = data?[selectedIndex]
            } else {
                self.selectedIndex = nil
            }
            text = textFieldValue
        }
    }
    
    /**
     Init picker view
     */
    private func initPickerView() {
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        // finding selected row
        let mathedIndex = self.data?.firstIndex(where: {$0.lowercased() == self.text!.lowercased() })
            selectedIndex = mathedIndex
        
        // set previouly selected row
        if var selectedIndex = selectedIndex {
            if shouldShowBlankRow {
                selectedIndex += 1
            }
            pickerView?.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        inputView = pickerView
    }
    
    /**
     Deinit picker view
     */
    private func deInitPickerView() {
        pickerView = nil
    }
    
    //MARK:- Public methods
    /**
    To set the data for picker view
    - parameters:
       - data: array of data to be shown in picker view
       - blankRowTitle: To set the blank row, default is nil.
    */
    public func set(data: [String]?, blankRowTitle: String? = nil) {
        self.data = data
        self.shouldShowBlankRow = blankRowTitle != nil
        if let blankRow = blankRowTitle, data != nil {
            self.data?.insert(blankRow, at: 0)
        }
    }
    
}


//MARK:- Picker view delegates
extension PickerTextField: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setSelectedData()
        pickerTextFieldDelegate?.didSelect(textField: self, index: selectedIndex)
    }
}

//MARK:- Picker view data sources
extension PickerTextField: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?[row]
    }
}

//MARK:- Text field data source
extension PickerTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        initPickerView()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        setSelectedData()
        pickerTextFieldDelegate?.didSelect(textField: self, index: selectedIndex)
        pickerTextFieldDelegate?.didEndEditing(textField: self, index: selectedIndex)
        deInitPickerView()
    }
}

//MARK:- Picker text field delegate
public protocol PickerTextFieldDelegate: class {
    /**
    Sends selected index
    - parameters:
       - index: selected index
    */
    func didSelect(textField:PickerTextField, index: Int?) // Fires every time on row selection
    func didEndEditing(textField: PickerTextField, index: Int?)
}

extension PickerTextFieldDelegate {
    func didEndEditing(textField: PickerTextField, index: Int?) {}
}
