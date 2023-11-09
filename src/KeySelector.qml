import QtQuick
import QtQuick.Layouts

Loader
{
    id: control
    property string key
    property string displayText
    property string modeSwitchTarget: ""
    property real widthFactor: -1
    Layout.preferredHeight: item.Layout.fillWidth ? 0 : item.height
    Layout.preferredWidth: item.Layout.fillWidth ? 0 : item.width

    signal switchToKeySet(string value)

    Layout.fillWidth: item.Layout.fillWidth

    /**
     * The delegate that paints the key buttons
     */
    Component {
        id: keyButtonDelegate
        KeyButton {
            id: button
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : pimpl.buttonWidth)
            height: pimpl.rowHeight
            text: (pimpl.shiftModifier) ? control.key.toUpperCase() : control.key
            displayText: control.displayText != "" ? control.displayText : text
            font: root.font
            inputPanel: root
        }
    }
    Component
    {
        id: hideKeyComponent

        KeyButton {
            color: "#1e1b18"
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 1.25 * pimpl.buttonWidth)
            height: pimpl.rowHeight
            font.family: "FontAwesome"
            text: "\uf078"
            displayText: control.displayText != "" ? control.displayText : text
            functionKey: true
            onClicked: {
                forceActiveFocus();
                Qt.inputMethod.hide();
                root.model.hide();
            }
            inputPanel: root
            showPreview: false
        }
    }
    Component
    {
        id: spacerComponent
        Item
        {
            implicitWidth: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : pimpl.buttonWidth)
        }
    }

    Component
    {
        id: spaceKeyComponent

        KeyButton {
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 3*pimpl.buttonWidth)
            height: pimpl.rowHeight
            text: " "
            displayText: control.displayText != "" ? control.displayText : text
            font: root.font
            inputPanel: root
            showPreview: false
        }
    }
    Component
    {
        id: modeSwitchKeyComponent
        KeyButton {
            color: "#1e1b18"
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 1.25*pimpl.buttonWidth)
            height: pimpl.rowHeight
            text: ""
            displayText: control.displayText != "" ? control.displayText : "###"
            font: root.font
            functionKey: true
            onClicked: {
                if (pimpl.shiftModifier) {
                    pimpl.shiftModifier = false
                }
                control.switchToKeySet(control.modeSwitchTarget);
            }
            inputPanel: root
        }
    }
    Component
    {
        id: enterKeyComponent
        KeyButton {
            color: "#1e1b18"
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 1.25*pimpl.buttonWidth)
            height: pimpl.rowHeight
            displayText: control.displayText != "" ? control.displayText : "Enter"
            text: "\n"
            font: root.font
            inputPanel: root

            onPressed:
            {
                root.enterPressed();
            }
        }
    }
    Component
        {
        id: softEnterKeyComponent
        KeyButton {
            color: "#1e1b18"
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 1.25*pimpl.buttonWidth)
            height: pimpl.rowHeight
            displayText: control.displayText != "" ? control.displayText : "Enter"
            font: root.font
            inputPanel: root

            onPressed:
                {
                root.enterPressed();
            }
        }
    }
    Component
    {
        id: shiftKeyComponent
        KeyButton {
            color: (pimpl.shiftModifier)? "#1e6fa7": "#1e1b18"
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 1.25 * pimpl.buttonWidth)
            height: pimpl.rowHeight
            font.family: "FontAwesome"
            text: "\uf062"
            displayText: control.displayText != "" ? control.displayText : text
            functionKey: true
            inputPanel: root

            onClicked:
            {
                pimpl.shiftModifier = !pimpl.shiftModifier
            }
        }
    }
    Component
    {
        id: backspaceKeyComponent
        KeyButton {
            font.family: "FontAwesome"
            color: "#1e1b18"
            width: Math.round(control.widthFactor > 0 ? control.widthFactor * pimpl.buttonWidth : 1.25 * pimpl.buttonWidth)
            height: pimpl.rowHeight
            text: "\x7F"
            displayText: control.displayText != "" ? control.displayText : "\uf177"

            inputPanel: root
            repeat: true
        }
    }

    Component
    {
        id: fillWidthComponent
        Item
        {
            Layout.fillWidth: true
        }
    }

    sourceComponent:
    {
        switch(control.key)
        {
            case "hideKey":
                return hideKeyComponent;
            case "spacer":
                return spacerComponent;
            case "spaceKey":
                return spaceKeyComponent;
            case "modeSwitchKey":
                return modeSwitchKeyComponent;
            case "enterKey":
                return enterKeyComponent;
            case "softEnterKey":
                return softEnterKeyComponent;
            case "shiftKey":
                return shiftKeyComponent;
            case "backspaceKey":
                return backspaceKeyComponent;
            case "fillWidth":
                return fillWidthComponent;
            default:
                return keyButtonDelegate;
        }
    }
}
