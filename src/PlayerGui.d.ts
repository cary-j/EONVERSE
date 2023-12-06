interface LoadingUi extends Instance {
    //    Loading: ScreenGui & {
    Primary: Frame & {
        Top: Frame & {
            F0: Frame & {
                UICorner: UICorner;
                UIStroke: UIStroke;
                UIGradient: UIGradient;
            };
            F1: Frame & {
                UICorner: UICorner;
                UIGradient: UIGradient;
            };
            F2: Frame & {
                UICorner: UICorner;
                UIGradient: UIGradient;
            };
            F3: Frame & {
                UICorner: UICorner;
                UIGradient: UIGradient;
            };
            F5: Frame & {
                UICorner: UICorner;
                UIGradient: UIGradient;
            };
            F4: Frame & {
                UICorner: UICorner;
                UIGradient: UIGradient;
            };
        };
        Bottom: Frame & {
            CurrentLoading: TextLabel;
        };
    }
}

interface PlayerGui extends Instance {
    Loading: ScreenGui & LoadingUi;
    MainServer: ScreenGui & {
        CreateServer: Frame & {
            ReturnButton: TextButton & {
                UICorner: UICorner;
                UIStroke: UIStroke;
                UIScale: UIScale;
            };
            PrivacyLabel: TextLabel;
            CreateButton: TextButton & {
                UICorner: UICorner;
                UIStroke: UIStroke;
                UIScale: UIScale;
            };
            PrivacyStatusNew: Frame & {
                Public: TextButton;
                Private: TextButton;
                UIStroke: UIStroke;
                UICorner: UICorner;
                Slider: Frame & {
                    UICorner: UICorner;
                };
            };
            ImageLabel: ImageLabel;
        };
        Primary: Frame & {
            ListServers: TextButton & {
                UICorner: UICorner;
                UIStroke: UIStroke;
                UIScale: UIScale;
            };
            ServerCodeSubmit: ImageButton & {
                UIScale: UIScale;
            };
            CreateServer: TextButton & {
                UICorner: UICorner;
                UIStroke: UIStroke;
                UIScale: UIScale;
            };
            ServerCodeInput: TextBox & {
                UICorner: UICorner;
                UIStroke: UIStroke;
            };
            ImageLabel: ImageLabel;
        };
        ListServers: Frame & {
            OwnerLabel: TextLabel;
            PrivacyLabel: TextLabel;
            ScrollingFrame: ScrollingFrame & {
                UIGridLayout: UIGridLayout;
            };
            ImageLabel: ImageLabel;
        };
    };
}
