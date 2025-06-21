{
  fetchNuGet,
  musl,
  fontconfig,
}:
[
  (fetchNuGet {
    pname = "Apizr";
    version = "6.3.0";
    hash = "sha256-3oaGuVUZFPa4HrDradNuNtv2oTZ276WOeulLn5KUadA=";
  })
  (fetchNuGet {
    pname = "Apizr.Extensions.Microsoft.Caching";
    version = "6.3.0";
    hash = "sha256-cmVAtrgY5dWFOc33ZvW1JPhudsFkcWDUNQjnLGwrIIU=";
  })
  (fetchNuGet {
    pname = "Apizr.Extensions.Microsoft.DependencyInjection";
    version = "6.3.0";
    hash = "sha256-i82C1wy27Oy4cW1ds+CCqFokqvtn5Gw8r6pxIIUFhHA=";
  })
  (fetchNuGet {
    pname = "Apizr.Integrations.Fusillade";
    version = "6.3.0";
    hash = "sha256-C+5HoHj/uoBtbDl88uq+aZyO5dtC7aMRO4wsfSBw1sw=";
  })
  (fetchNuGet {
    pname = "AsyncAwaitBestPractices";
    version = "9.0.0";
    hash = "sha256-GqYkuv4n85BRgjj+L0Kyuo2ojAEnoD4jn/oYd0mYxBs=";
  })
  (fetchNuGet {
    pname = "AsyncImageLoader.Avalonia";
    version = "3.2.1";
    hash = "sha256-WBn3WYauo+B4pZ7HQNJfQrngyac8YHJOYafIXB/Z8+A=";
  })
  (fetchNuGet {
    pname = "AutoComplete.Net";
    version = "1.2211.2014.42";
    hash = "sha256-M5v/hGGH2ZGDE9PIBDEyIEA4N9rriCFnbw+QImIaTHc=";
  })
  (fetchNuGet {
    pname = "AutoCtor";
    version = "2.4.1";
    hash = "sha256-oQOS5jywuwhYjavcnWdtp3Jk+84D1xFbNNXZab50fIU=";
  })
  (fetchNuGet {
    pname = "Avalonia";
    version = "11.2.5";
    hash = "sha256-DGTMzInnfvJUJWu2SXiRBercxxe1/paQkSlBHMahp4g=";
  })
  (fetchNuGet {
    pname = "Avalonia.Angle.Windows.Natives";
    version = "2.1.22045.20230930";
    hash = "sha256-RxPcWUT3b/+R3Tu5E5ftpr5ppCLZrhm+OTsi0SwW3pc=";
  })
  (fetchNuGet {
    pname = "Avalonia.AvaloniaEdit";
    version = "11.1.0";
    hash = "sha256-K9+hK+4aK93dyuGytYvVU25daz605+KN54hmwQYXFF8=";
  })
  (fetchNuGet {
    pname = "Avalonia.BuildServices";
    version = "0.0.31";
    hash = "sha256-wgtodGf644CsUZEBIpFKcUjYHTbnu7mZmlr8uHIxeKA=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.ColorPicker";
    version = "11.1.0";
    hash = "sha256-xawQhivop0f7n98Xqj5fScDdF0RPPpVIoTpVs+p6T3Q=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.ColorPicker";
    version = "11.1.1";
    hash = "sha256-L9w3jA7ySo9mePP1vmhdiyTwBmNG34fCuR+trMa9jv8=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.ColorPicker";
    version = "11.2.5";
    hash = "sha256-gWGIqXrac0fOnmGbovcFWv5Uj14hOyC+n0l45N7owMg=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.DataGrid";
    version = "11.2.5";
    hash = "sha256-eGKc+UnsO5nNiUd7+n3CQW6vIWq2qpazYvYXrVTQY7s=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.ItemsRepeater";
    version = "11.1.4";
    hash = "sha256-T8+x8mUGtuEgVNxrUmEn/Kwp2tYsl3ITpY/EQz+3lIs=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.PanAndZoom";
    version = "11.2.0";
    hash = "sha256-L5lXJj9Cf/ULnMf+abEsvTfWd8ku+fe9yr7jJs0a6eM=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.ProportionalStackPanel";
    version = "11.2.0";
    hash = "sha256-Y8tX7dBzSl69NOSNdpNGzGetc6wQtKnFy/KRnV0SKhQ=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.Recycling";
    version = "11.2.0";
    hash = "sha256-ylsPhtILO0pk+5uPZKB5L1o7X8JTiOe48czPPLYLyVs=";
  })
  (fetchNuGet {
    pname = "Avalonia.Controls.Recycling.Model";
    version = "11.2.0";
    hash = "sha256-zAleY6ryWIexJAzz4BpT/Xd3iDgNL624YW5sIBJ0Sv8=";
  })
  (fetchNuGet {
    pname = "Avalonia.Desktop";
    version = "11.2.5";
    hash = "sha256-rDJ1NJM3tEqB7sRszj0AfplwkkvtE3Hvn7acrIsq+yw=";
  })
  (fetchNuGet {
    pname = "Avalonia.Diagnostics";
    version = "11.2.5";
    hash = "sha256-WsAMBmNfUKMB2II3AfM8A0klfJR/vgEtRUTGpgC6F3A=";
  })
  (fetchNuGet {
    pname = "Avalonia.Fonts.Inter";
    version = "11.2.5";
    hash = "sha256-cPdNS/VWH6yZ/9Ea+U5UBx6RgC0SpkhKonBxZ6InLLU=";
  })
  (fetchNuGet {
    pname = "Avalonia.FreeDesktop";
    version = "11.2.5";
    hash = "sha256-rLzsxUQS1LLLcLWkDR8SLLwLY53vUMqgiKoDWM6PjtM=";
  })
  (fetchNuGet {
    pname = "Avalonia.HtmlRenderer";
    version = "11.0.0";
    hash = "sha256-DBD113eQJNHeEgFmx/tVRSnHxhGBQIKWVKxr1QRilr4=";
  })
  (fetchNuGet {
    pname = "Avalonia.Labs.Controls";
    version = "11.2.0";
    hash = "sha256-PIdJ7kSEhdAPB7YZJSu4koExj57m76eaQP4rpyId45U=";
  })
  (fetchNuGet {
    pname = "Avalonia.MarkupExtension";
    version = "11.2.0";
    hash = "sha256-BUEMX+YThWmxh9X50bGsFtclLFVSIITMlAf0iq2vApk=";
  })
  (fetchNuGet {
    pname = "Avalonia.Native";
    version = "11.2.5";
    hash = "sha256-XQQgcfbRRHPzH432M1KzkSEtLQof40yCt+KIrQREBY0=";
  })
  (fetchNuGet {
    pname = "Avalonia.Remote.Protocol";
    version = "11.2.5";
    hash = "sha256-Mpml6U6Fl8FUvENGQxpxuw0+pOPvoWbZXV4V1bLUS9w=";
  })
  (fetchNuGet {
    pname = "Avalonia.Skia";
    version = "11.0.0";
    hash = "sha256-A01nrs3Ij1eTo6tPmu7++T1K+Wo/H/9LvpeuOUGbQeU=";
  })
  (fetchNuGet {
    pname = "Avalonia.Skia";
    version = "11.1.0";
    hash = "sha256-w4ozV8lIs5vxoYP5D5Lut2iTMiJKVPbjdtqDB1sb0MI=";
  })
  (fetchNuGet {
    pname = "Avalonia.Skia";
    version = "11.2.5";
    hash = "sha256-su1K1RmQ+syE6ufjrzpQR1yiUa6GEtY5QPlW0GOVKnU=";
  })
  (fetchNuGet {
    pname = "Avalonia.Svg";
    version = "11.2.0";
    hash = "sha256-qo8p1V3cAduFtOqp/n8o4WxHxGRL9GatjhheMgx/EvE=";
  })
  (fetchNuGet {
    pname = "Avalonia.Themes.Simple";
    version = "11.2.5";
    hash = "sha256-EjQ2XA81SS91h8oGUwVxLYewm3Lp5Sa2Lmbj0c8y8BU=";
  })
  (fetchNuGet {
    pname = "Avalonia.Win32";
    version = "11.2.5";
    hash = "sha256-ljgJgXDxmHOUQ+p8z62mtaK4FTmYAI+c+6gL2lczD/8=";
  })
  (fetchNuGet {
    pname = "Avalonia.X11";
    version = "11.2.5";
    hash = "sha256-wHEHcEvOUyIBgBtQZOIs330KajSv8DSEsJP7w4M9i4E=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Behaviors";
    version = "11.2.0";
    hash = "sha256-I9aELyXkzLGX6T4HUFbCQxn+eWqLLPK0xqEiF+6hi5k=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactions";
    version = "11.2.0";
    hash = "sha256-Wnt4xra+TPRiAJ5TIyefwkRxxA999THBstm8QuLXZlU=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactions.Custom";
    version = "11.2.0";
    hash = "sha256-vLOTOHwy7RRrgrYFUetAIWSC+Pm6yxzb3Ko2BPtXGUo=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactions.DragAndDrop";
    version = "11.2.0";
    hash = "sha256-rAHnjsMnaZCf+dMWe3fZAsnwY2LKFJuTVzsyNzWnh2Q=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactions.Draggable";
    version = "11.2.0";
    hash = "sha256-WI3JZm+IuKpdlhw1XpgPXJs+e9P97l0odSHPM8SSrqw=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactions.Events";
    version = "11.2.0";
    hash = "sha256-z1DGsetBjrzTP1pLWSqP748bl6tDWWOUlvuPc7WHb1k=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactions.Responsive";
    version = "11.2.0";
    hash = "sha256-V1YHBrPEKBgHYmEdhWmzz7NOSwExYMaz3J0N0s53Gl0=";
  })
  (fetchNuGet {
    pname = "Avalonia.Xaml.Interactivity";
    version = "11.2.0";
    hash = "sha256-N3maAwWG//4uHAEvux0/BwanQLviMm7uo6jxIj4kB8s=";
  })
  (fetchNuGet {
    pname = "AvaloniaEdit.TextMate";
    version = "11.0.6";
    hash = "sha256-7QpWP6gt0aA/2P+WK0JzX9n90R0Gy/e3cQntAUmAuBw=";
  })
  (fetchNuGet {
    pname = "Blake3";
    version = "1.1.0";
    hash = "sha256-gSXmXolZOlon1UG2miI9bdS1542vGR8EyukwIkqXdoE=";
  })
  (fetchNuGet {
    pname = "bodong.Avalonia.PropertyGrid";
    version = "11.1.1.1";
    hash = "sha256-mq/nXSgRRfYD1PHZKNGOm5r3h6olkr0M9cRIySWQ+KQ=";
  })
  (fetchNuGet {
    pname = "bodong.PropertyModels";
    version = "11.1.1.1";
    hash = "sha256-7dn+psRCYOiYqFRfzICb32TIgUKvuVmEnVoNT6UNcIE=";
  })
  (fetchNuGet {
    pname = "Castle.Core";
    version = "5.1.1";
    hash = "sha256-oVkQB+ON7S6Q27OhXrTLaxTL0kWB58HZaFFuiw4iTrE=";
  })
  (fetchNuGet {
    pname = "CodeGeneration.Roslyn.Attributes";
    version = "0.7.63";
    hash = "sha256-wHAYZqPJJCrHUwAoKluqke34u05/S983g4dIdtWcTlw=";
  })
  (fetchNuGet {
    pname = "CodeGeneration.Roslyn.Tool";
    version = "0.7.63";
    hash = "sha256-WI4dDRqfyWxhTYYSZW/DsWJDJIHpaztpyMNwBJXgyzk=";
  })
  (fetchNuGet {
    pname = "ColorDocument.Avalonia";
    version = "11.0.3-a1";
    hash = "sha256-Pkh5FX+4pBzep5oCCyhIiR559QyFCEb1vrfEgG0wREw=";
  })
  (fetchNuGet {
    pname = "ColorTextBlock.Avalonia";
    version = "11.0.3-a1";
    hash = "sha256-fWJuApxnJLISayQJIKEBVOt/t1Qyj+0s+RezZkMnPio=";
  })
  (fetchNuGet {
    pname = "CommandLineParser";
    version = "2.9.1";
    hash = "sha256-ApU9y1yX60daSjPk3KYDBeJ7XZByKW8hse9NRZGcjeo=";
  })
  (fetchNuGet {
    pname = "CommunityToolkit.Mvvm";
    version = "8.2.2";
    hash = "sha256-vdprWEw+J6yJZLWZTUFTrQAHWLuPVXPBaYmePD7kcwY=";
  })
  (fetchNuGet {
    pname = "CompiledExpressions";
    version = "1.1.0";
    hash = "sha256-4aabvPJ6Hl/8qbfhxKyynmn9drYpIo5kEkyAU5x4cfI=";
  })
  (fetchNuGet {
    pname = "Crc32.NET";
    version = "1.2.0";
    hash = "sha256-sMQNIppJXHU2mULn5b//uRbbPMyguH9QlG6HKVIYUmE=";
  })
  (fetchNuGet {
    pname = "CSharpDiscriminatedUnion";
    version = "2.0.1";
    hash = "sha256-2DvoGVm2GBbb7zgblrHkCgLJvcTflzItGGeT0SJxtoc=";
  })
  (fetchNuGet {
    pname = "CSharpDiscriminatedUnion.Attributes";
    version = "2.0.1";
    hash = "sha256-KJWXZW1f9WNVvRymLGfegT4dwT3e/uVVaxuplfA1RB4=";
  })
  (fetchNuGet {
    pname = "CSharpDiscriminatedUnion.Generator";
    version = "2.0.1";
    hash = "sha256-1lK0gOI3lJ/8Dno3hVQwb+FP2aA/eHUQJc9s6n6DPu8=";
  })
  (fetchNuGet {
    pname = "DesktopNotifications";
    version = "1.3.1";
    hash = "sha256-mfs9t6k7TIP9A5sStWrZkrTMetceMMPzXb1ZFqGQPhw=";
  })
  (fetchNuGet {
    pname = "DesktopNotifications.Avalonia";
    version = "1.3.1";
    hash = "sha256-ExOgVRadEQfGPV+iA6GcIDhRdJJROP0MQFLgoXFr3hk=";
  })
  (fetchNuGet {
    pname = "DesktopNotifications.FreeDesktop";
    version = "1.3.1";
    hash = "sha256-rjmjs0Gs/+CcGm3Kc4BKiu0tV5dOu6mkPYBghxryQ38=";
  })
  (fetchNuGet {
    pname = "DesktopNotifications.Windows";
    version = "1.3.1";
    hash = "sha256-+1/Bbut9HAbQIU/STfyZimz80Uiz516CifkrTGc0dqY=";
  })
  (fetchNuGet {
    pname = "DeviceId";
    version = "6.7.0";
    hash = "sha256-Hqz/OHQ9fcGQk0yxT7aT+Bez7WCngEjkdcckeQNlMAk=";
  })
  (fetchNuGet {
    pname = "DeviceId.Linux";
    version = "6.4.0";
    hash = "sha256-Gx1A6HaT8UAC7PKJyeGKYkHc1ewr8kY2XaZY4l4wtTg=";
  })
  (fetchNuGet {
    pname = "DeviceId.Mac";
    version = "6.3.0";
    hash = "sha256-CyjkPYiyppvSeme1WZyXbmmrGVvoAP3xLcnMhRB2t6Q=";
  })
  (fetchNuGet {
    pname = "DeviceId.Windows";
    version = "6.6.0";
    hash = "sha256-44lwgZHU0ehGmgNNbm2L3h3jraNyKXAoXMNQFae8pP4=";
  })
  (fetchNuGet {
    pname = "DeviceId.Windows.Wmi";
    version = "6.6.0";
    hash = "sha256-FGbzb4lUmFZC+hcliCfVlMBeqQSyUyysRGg5JIKfzCk=";
  })
  (fetchNuGet {
    pname = "DiscordRichPresence";
    version = "1.2.1.24";
    hash = "sha256-oRNrlF1/yK0QvrW2+48RsmSg9h9/pDIfA56/bpoHXFU=";
  })
  (fetchNuGet {
    pname = "Dock.Avalonia";
    version = "11.2.0";
    hash = "sha256-Q8YUsH+hfnL9VDMPTJSAms7xb+hr42p7scWqu2c2eD4=";
  })
  (fetchNuGet {
    pname = "Dock.Model";
    version = "11.2.0";
    hash = "sha256-+PSgjxvHIJBQRn8naGgSfYyArImVLwy6ftm9FoQc+lA=";
  })
  (fetchNuGet {
    pname = "Dock.Model.Avalonia";
    version = "11.2.0";
    hash = "sha256-aqfbbkjcAHznFTw+8OBxdzSgWBmqhg6bONTRlV94Rn8=";
  })
  (fetchNuGet {
    pname = "Dock.Serializer";
    version = "11.2.0";
    hash = "sha256-ODhyS+PHX614Ogi0HcPqEMQjzFr3BL94Pg6KGoENOWE=";
  })
  (fetchNuGet {
    pname = "Dock.Settings";
    version = "11.2.0";
    hash = "sha256-esCRl7Trdv2bu2ayLw5kXVtCskXLar1asykkfWnqhug=";
  })
  (fetchNuGet {
    pname = "DotNet.Bundle";
    version = "0.9.13";
    hash = "sha256-VA7wFPC2V4JudQ+edk6lFkklDPIHZYVWql8/KMzcnys=";
  })
  (fetchNuGet {
    pname = "DynamicData";
    version = "9.0.1";
    hash = "sha256-dvo4eSHg8S9oS5QhvfCrbV+y7BVtlYRwH7PN7N1GubM=";
  })
  (fetchNuGet {
    pname = "DynamicData";
    version = "9.3.1";
    hash = "sha256-vSHIncycGySgHxEcBpCwK5ZJhJTlqyz/rO17x3sZ2jc=";
  })
  (fetchNuGet {
    pname = "Exceptionless.DateTimeExtensions";
    version = "3.4.3";
    hash = "sha256-ulAsmV5Pdvum9yZutbXiRn0cpABq/C7DBudPbJnA/S0=";
  })
  (fetchNuGet {
    pname = "ExCSS";
    version = "4.2.3";
    hash = "sha256-M/H6P5p7qqdFz/fgAI2MMBWQ7neN/GIieYSSxxjsM9I=";
  })
  (fetchNuGet {
    pname = "ExifLibNet";
    version = "2.1.4";
    hash = "sha256-MKCtsFjQ/9GB4YUPvtAtZk+5SqaFDFESOciFX29qxaQ=";
  })
  (fetchNuGet {
    pname = "FluentAvalonia.BreadcrumbBar";
    version = "2.0.2";
    hash = "sha256-JB1GiTESry2ZbH5q0vy32QqTr+DNJdaLSTxTBvQcAOs=";
  })
  (fetchNuGet {
    pname = "FluentAvaloniaUI";
    version = "2.2.0";
    hash = "sha256-rWlR07GfyBOAau2mSuPN0sCxlUrxfeowYO6uWDe4LM0=";
  })
  (fetchNuGet {
    pname = "FluentAvaloniaUI";
    version = "2.3.0";
    hash = "sha256-a+zLB5uGAjrw+FuBH0pzsnbY9cmYAAmix2K+ALmKgjI=";
  })
  (fetchNuGet {
    pname = "FluentIcons.Avalonia";
    version = "1.1.249";
    hash = "sha256-TuaqzGsgg+qJ8SAswQX80L1s2wVqzblAl+i6cDdvDdI=";
  })
  (fetchNuGet {
    pname = "FluentIcons.Avalonia";
    version = "1.1.293";
    hash = "sha256-q9bmkUgxysaM5YQX6HfA22gCwLpEgSZyILGECZF20Rc=";
  })
  (fetchNuGet {
    pname = "FluentIcons.Avalonia.Fluent";
    version = "1.1.249";
    hash = "sha256-OoGUKj8TW4vV52ugIoo297FSqX8Q9PjiRjz3jJkCcFw=";
  })
  (fetchNuGet {
    pname = "FluentIcons.Avalonia.Fluent";
    version = "1.1.293";
    hash = "sha256-G4/gI0UO0lBJuZciqLJD9CrHjL0DkhTWOj4vt0kD85Q=";
  })
  (fetchNuGet {
    pname = "FluentIcons.Common";
    version = "1.1.249";
    hash = "sha256-keKGSqFG8Z9XzGuEh+TtSw+kZg+AgxT01T6zkEbtdqw=";
  })
  (fetchNuGet {
    pname = "FluentIcons.Common";
    version = "1.1.293";
    hash = "sha256-0ov0Yb0JPxF0Kvr2wUnHDpAaoN7RzPKe93qwQD5FPfE=";
  })
  (fetchNuGet {
    pname = "FreneticLLC.FreneticUtilities";
    version = "1.0.32";
    hash = "sha256-JMTxXMafSEBCMnNLK+awbB/m8ofToxExCdJA0D6xNuo=";
  })
  (fetchNuGet {
    pname = "fusillade";
    version = "2.6.30";
    hash = "sha256-uq1zaF8RdbThgM/1L8VRzdkUVxeJzk8cN25y81HF0Mw=";
  })
  (fetchNuGet {
    pname = "FuzzySharp";
    version = "2.0.2";
    hash = "sha256-GuWqVOo+AG8MSvIbusLPjKfJFQRJhSSJ9eGWljTBA/c=";
  })
  (fetchNuGet {
    pname = "Hardware.Info";
    version = "100.1.0.1";
    hash = "sha256-z9dLW2LgXM3WW/5lPn9UkIdM5o7dI9qw4WXFBUkyA0o=";
  })
  (fetchNuGet {
    pname = "HarfBuzzSharp";
    version = "7.3.0.3";
    hash = "sha256-1vDIcG1aVwVABOfzV09eAAbZLFJqibip9LaIx5k+JxM=";
  })
  (fetchNuGet {
    pname = "HarfBuzzSharp.NativeAssets.Linux";
    version = "7.3.0.3";
    hash = "sha256-HW5r16wdlgDMbE/IfE5AQGDVFJ6TS6oipldfMztx+LM=";
  })
  (fetchNuGet {
    pname = "HarfBuzzSharp.NativeAssets.macOS";
    version = "7.3.0.3";
    hash = "sha256-UpAVfRIYY8Wh8xD4wFjrXHiJcvlBLuc2Xdm15RwQ76w=";
  })
  (fetchNuGet {
    pname = "HarfBuzzSharp.NativeAssets.WebAssembly";
    version = "7.3.0.3";
    hash = "sha256-jHrU70rOADAcsVfVfozU33t/5B5Tk0CurRTf4fVQe3I=";
  })
  (fetchNuGet {
    pname = "HarfBuzzSharp.NativeAssets.Win32";
    version = "7.3.0.3";
    hash = "sha256-v/PeEfleJcx9tsEQAo5+7Q0XPNgBqiSLNnB2nnAGp+I=";
  })
  (fetchNuGet {
    pname = "HtmlAgilityPack";
    version = "1.11.42";
    hash = "sha256-y1sdZXb4+wjvH5gmwyBZOn5CLid7lTHgxEsy13BgdjM=";
  })
  (fetchNuGet {
    pname = "Humanizer.Core";
    version = "2.14.1";
    hash = "sha256-EXvojddPu+9JKgOG9NSQgUTfWq1RpOYw7adxDPKDJ6o=";
  })
  (fetchNuGet {
    pname = "Injectio";
    version = "4.0.0";
    hash = "sha256-nGohm3HEytGpD3eJ5iMNBkfLN1iNXNgqIkApfY9CBJA=";
  })
  (fetchNuGet {
    pname = "JetBrains.Annotations";
    version = "2024.2.0";
    hash = "sha256-OgtW4wIqo5d3q6NSiYrUm4KkUdUHEWFyvlbtoQJjDwU=";
  })
  (fetchNuGet {
    pname = "KeyedSemaphores";
    version = "5.0.0";
    hash = "sha256-b7VupMxX0AmLqpPUy9PmYe3QXrf+zsh8We0Hos27ZGs=";
  })
  (fetchNuGet {
    pname = "KGySoft.CoreLibraries";
    version = "8.1.0";
    hash = "sha256-uISK7QNAoiLWSwtvzl4KnttvWlIDeLIBPTP6oH5n2yA=";
  })
  (fetchNuGet {
    pname = "KGySoft.Drawing.Core";
    version = "8.1.0";
    hash = "sha256-88WQ1DypHjbNxZLzwm7moSq8nfwSJ5S3vb1iRTp2nB8=";
  })
  (fetchNuGet {
    pname = "KGySoft.Drawing.SkiaSharp";
    version = "8.1.0";
    hash = "sha256-cO0Lu7icEe+KiW/L7cK1pJqcACuYLX4vUlaK3EJ3/oE=";
  })
  (fetchNuGet {
    pname = "libsodium";
    version = "1.0.19";
    hash = "sha256-EXeaeLf3kpeFw5ecr/D/hZbOdSH+t518pV6HwOxc8ec=";
  })
  (fetchNuGet {
    pname = "LiteDB";
    version = "5.0.21";
    hash = "sha256-k4pPX51qKDg96Mz8vbiJfnhDI5khUjLPONvxR+A+wWc=";
  })
  (fetchNuGet {
    pname = "LiteDB.Async";
    version = "0.1.8";
    hash = "sha256-9RT4xvc4IFlj129gfZHnpOTYNEu+pUaY8+/rGIq6Ju0=";
  })
  (fetchNuGet {
    pname = "Markdig";
    version = "0.38.0";
    hash = "sha256-5DuDlj+TCDJWP8oJM2WU48ps3HFuUg5P28O/SPcjwGk=";
  })
  (fetchNuGet {
    pname = "Markdown.Avalonia";
    version = "11.0.3-a1";
    hash = "sha256-tzSWAz/fVQ58EFbSIWO/UoNWQlRJ3g1XA78wYWflLV0=";
  })
  (fetchNuGet {
    pname = "Markdown.Avalonia.Html";
    version = "11.0.3-a1";
    hash = "sha256-rpQiHK/UXEQgbJuaejDirhHJxWjGTpF7ddsEmcP6Pe4=";
  })
  (fetchNuGet {
    pname = "Markdown.Avalonia.Svg";
    version = "11.0.3-a1";
    hash = "sha256-nTuS+2wGv0Y+envK3Sgt+sdXKSHe8qOt8AVl6QbdjfQ=";
  })
  (fetchNuGet {
    pname = "Markdown.Avalonia.SyntaxHigh";
    version = "11.0.3-a1";
    hash = "sha256-t91Gok0OaMBFN/l+fYIoEG8nPWPeXJZZucjtn/23Dq0=";
  })
  (fetchNuGet {
    pname = "Markdown.Avalonia.Tight";
    version = "11.0.3-a1";
    hash = "sha256-KkRzr8BXmUCGCVv/64gg1aiXHUY0yGj5t12OsYAidcw=";
  })
  (fetchNuGet {
    pname = "MessagePack";
    version = "2.5.192";
    hash = "sha256-M9QUEAIeSoSgO3whVkOou0F8kbKCNJ7HHAvTZgytkPU=";
  })
  (fetchNuGet {
    pname = "MessagePack.Annotations";
    version = "2.5.192";
    hash = "sha256-DLtncnaQ9Sp5YmWm89+2w3InhdU1ZQxnJgbonAq/1aM=";
  })
  (fetchNuGet {
    pname = "MessagePipe";
    version = "1.8.1";
    hash = "sha256-imKh6p2op+5GOPxcABZk2RiqHdeT71I16l4qahq94yU=";
  })
  (fetchNuGet {
    pname = "MessagePipe.Interprocess";
    version = "1.8.1";
    hash = "sha256-/pEaD9rBurqmZfH3nYAdLnE60tIvS7V5Rde4ukDwu/4=";
  })
  (fetchNuGet {
    pname = "MetadataExtractor";
    version = "2.8.1";
    hash = "sha256-pMapwCBv3OouNE9c9xfimFUKtZVQsJ6EAQSdQ95zgrk=";
  })
  (fetchNuGet {
    pname = "MicroCom.Runtime";
    version = "0.11.0";
    hash = "sha256-VdwpP5fsclvNqJuppaOvwEwv2ofnAI5ZSz2V+UEdLF0=";
  })
  (fetchNuGet {
    pname = "Microsoft.AspNetCore.App.Ref";
    version = "8.0.14";
    hash = "sha256-/KLfqaH4v++SyVJR9p+2WxrMDKPEZKmUvLUjB2ZwT/0=";
  })
  (fetchNuGet {
    pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "8.0.14";
    hash = "sha256-HGSGesUhWei4IE+jqGh85aokkIg7xufpVn+n1vOLoY4=";
  })
  (fetchNuGet {
    pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "9.0.3";
    hash = "sha256-hN8R6IVR+takaeSxnErhPWS/6SGbhzLkNYs+fPmZTl0=";
  })
  (fetchNuGet {
    pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "9.0.5";
    hash = "sha256-nnLCmUpx6HqBoCJihJbnRiwrYZwN2Lw3N3C27m6Vce4=";
  })
  (fetchNuGet {
    pname = "Microsoft.Bcl.AsyncInterfaces";
    version = "8.0.0";
    hash = "sha256-9aWmiwMJKrKr9ohD1KSuol37y+jdDxPGJct3m2/Bknw=";
  })
  (fetchNuGet {
    pname = "Microsoft.Bcl.HashCode";
    version = "1.1.1";
    hash = "sha256-gP6ZhEsjjbmw6a477sm7UuOvGFFTxZYfRE2kKxK8jnc=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Analyzers";
    version = "3.11.0";
    hash = "sha256-hQ2l6E6PO4m7i+ZsfFlEx+93UsLPo4IY3wDkNG11/Sw=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Analyzers";
    version = "3.3.4";
    hash = "sha256-qDzTfZBSCvAUu9gzq2k+LOvh6/eRvJ9++VCNck/ZpnE=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Common";
    version = "4.13.0";
    hash = "sha256-Bu5ev3JM+fyf9USnLM7AJbd5lFmpVfaxm6EQYoYM9Vc=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Common";
    version = "4.9.2";
    hash = "sha256-QU/nyiJWpdPQGHBdaOEVc+AghnGHcKBFBX0oyhRZ9CQ=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.CSharp";
    version = "4.13.0";
    hash = "sha256-jzO7/2j7rPqu4Xtm4lhh2Ijaiw+aUkiR+yYn+a8mg/M=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.CSharp";
    version = "4.9.2";
    hash = "sha256-j06Q4A9E65075SBXdXVCMRgeLxA63Rv1vxarydmmVAA=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.CSharp.Workspaces";
    version = "4.13.0";
    hash = "sha256-9zN6enlxCrwzQh8PdzCSt6yE98ridmH9gZDXM7GOgLc=";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Workspaces.Common";
    version = "4.13.0";
    hash = "sha256-chl7Yzf2gbXR6gQz9TEhJoeOTf6wfyuGg6hRhretPjU=";
  })
  (fetchNuGet {
    pname = "Microsoft.CSharp";
    version = "4.5.0";
    hash = "sha256-dAhj/CgXG5VIy2dop1xplUsLje7uBPFjxasz9rdFIgY=";
  })
  (fetchNuGet {
    pname = "Microsoft.CSharp";
    version = "4.7.0";
    hash = "sha256-Enknv2RsFF68lEPdrf5M+BpV1kHoLTVRApKUwuk/pj0=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.AmbientMetadata.Application";
    version = "8.4.0";
    hash = "sha256-rLGd9d4hZEG9iTCQLhHH7v6Iitn+JKzOOkQUbUa4QaY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Caching.Abstractions";
    version = "8.0.0";
    hash = "sha256-xGpKrywQvU1Wm/WolYIxgHYEFfgkNGeJ+GGc5DT3phI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Caching.Abstractions";
    version = "9.0.0";
    hash = "sha256-hDau5OMVGIg4sc5+ofe14ROqwt63T0NSbzm/Cv0pDrY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Caching.Memory";
    version = "9.0.0";
    hash = "sha256-OZVOVGZOyv9uk5XGJrz6irBkPNjxnBxjfSyW30MnU0s=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Compliance.Abstractions";
    version = "8.4.0";
    hash = "sha256-GQzw9jHOao398cylKWPkUvLtHRdqo6ziHlCJFVY7pgE=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration";
    version = "9.0.0";
    hash = "sha256-uBLeb4z60y8z7NelHs9uT3cLD6wODkdwyfJm6/YZLDM=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.Abstractions";
    version = "8.0.0";
    hash = "sha256-4eBpDkf7MJozTZnOwQvwcfgRKQGcNXe0K/kF+h5Rl8o=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.Abstractions";
    version = "9.0.0";
    hash = "sha256-xtG2USC9Qm0f2Nn6jkcklpyEDT3hcEZOxOwTc0ep7uc=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.Binder";
    version = "8.0.0";
    hash = "sha256-GanfInGzzoN2bKeNwON8/Hnamr6l7RTpYLA49CNXD9Q=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.Binder";
    version = "8.0.1";
    hash = "sha256-KYPQYYspiBGiez7JshmEjy4kFt7ASzVxQeVsygIEvHA=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.Binder";
    version = "9.0.0";
    hash = "sha256-6ajYWcNOQX2WqftgnoUmVtyvC1kkPOtTCif4AiKEffU=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.CommandLine";
    version = "9.0.0";
    hash = "sha256-RE6DotU1FM1sy5p3hukT+WOFsDYJRsKX6jx5vhlPceM=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.EnvironmentVariables";
    version = "9.0.0";
    hash = "sha256-tDJx2prYZpr0RKSwmJfsK9FlUGwaDmyuSz2kqQxsWoI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.FileExtensions";
    version = "9.0.0";
    hash = "sha256-PsLo6mrLGYfbi96rfCG8YS1APXkUXBG4hLstpT60I4s=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.Json";
    version = "9.0.0";
    hash = "sha256-qQn7Ol0CvPYuyecYWYBkPpTMdocO7I6n+jXQI2udzLI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Configuration.UserSecrets";
    version = "9.0.0";
    hash = "sha256-GoEk+Qq7lbiwWurHYx1LkDaUzIpOzaoTiVGDPfViGak=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection";
    version = "9.0.0";
    hash = "sha256-dAH52PPlTLn7X+1aI/7npdrDzMEFPMXRv4isV1a+14k=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "6.0.0";
    hash = "sha256-SZke0jNKIqJvvukdta+MgIlGsrP2EdPkkS8lfLg7Ju4=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "8.0.0";
    hash = "sha256-75KzEGWjbRELczJpCiJub+ltNUMMbz5A/1KQU+5dgP8=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "8.0.1";
    hash = "sha256-lzTYLpRDAi3wW9uRrkTNJtMmaYdtGJJHdBLbUKu60PM=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "8.0.2";
    hash = "sha256-UfLfEQAkXxDaVPC7foE/J3FVEXd31Pu6uQIhTic3JgY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "9.0.0";
    hash = "sha256-CncVwkKZ5CsIG2O0+OM9qXuYXh3p6UGyueTHSLDVL+c=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DependencyInjection.AutoActivation";
    version = "8.4.0";
    hash = "sha256-Hx5rToeCtp+URORIPqXQ3ofS5nRF18NSKuqa5miy7Cg=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.DiagnosticAdapter";
    version = "3.1.32";
    hash = "sha256-moN7Vt47IZ0ZHRMjW+Y1Vbn/7ekvkj9GSm4yjIeAGnI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Diagnostics";
    version = "8.0.0";
    hash = "sha256-fBLlb9xAfTgZb1cpBxFs/9eA+BlBvF8Xg0DMkBqdHD4=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Diagnostics";
    version = "8.0.1";
    hash = "sha256-CraHNCaVlMiYx6ff9afT6U7RC/MoOCXM3pn2KrXkiLc=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Diagnostics";
    version = "9.0.0";
    hash = "sha256-JMbhtjdcWRlrcrbgPlowfj26+pM+MYhnPIaYKnv9byU=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Diagnostics.Abstractions";
    version = "9.0.0";
    hash = "sha256-wG1LcET+MPRjUdz3HIOTHVEnbG/INFJUqzPErCM79eY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Diagnostics.ExceptionSummarization";
    version = "8.4.0";
    hash = "sha256-5D5FOJ+2JP2cbsCKYJNZ7JBAJ/DEXjWXJYXZN8AQC5c=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.FileProviders.Abstractions";
    version = "9.0.0";
    hash = "sha256-mVfLjZ8VrnOQR/uQjv74P2uEG+rgW72jfiGdSZhIfDc=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.FileProviders.Physical";
    version = "9.0.0";
    hash = "sha256-IzFpjKHmF1L3eVbFLUZa2N5aH3oJkJ7KE1duGIS7DP8=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.FileSystemGlobbing";
    version = "9.0.0";
    hash = "sha256-eBLa8pW/y/hRj+JbEr340zbHRABIeFlcdqE0jf5/Uhc=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Hosting";
    version = "9.0.0";
    hash = "sha256-apIN4Cz86ujsMp/ibxcvguA9uCFaFqOsZ4kAUPX5ASI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Hosting.Abstractions";
    version = "9.0.0";
    hash = "sha256-NhEDqZGnwCDFyK/NKn1dwLQExYE82j1YVFcrhXVczqY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Http";
    version = "8.0.0";
    hash = "sha256-UgljypOLld1lL7k7h1noazNzvyEHIJw+r+6uGzucFSY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Http";
    version = "8.0.1";
    hash = "sha256-ScPwhBvD3Jd4S0E7JQ18+DqY3PtQvdFLbkohUBbFd3o=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Http";
    version = "9.0.0";
    hash = "sha256-MsStH3oUfyBbcSEoxm+rfxFBKI/rtB5PZrSGvtDjVe0=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Http.Diagnostics";
    version = "8.4.0";
    hash = "sha256-OkDfVkXqFkSEpvqrPZq4A94SZbLtSvcvI4VToT0Ywdw=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Http.Polly";
    version = "9.0.0";
    hash = "sha256-xgzf8gfda/vJ7c6BkL4n12b54CvMaAJ9Sye7g+i+VlQ=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Http.Resilience";
    version = "8.4.0";
    hash = "sha256-1mp9ZG8D5XBX08tktsGqlPIJzA7gk6+GC8AyHkgTeLY=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging";
    version = "8.0.0";
    hash = "sha256-Meh0Z0X7KyOEG4l0RWBcuHHihcABcvCyfUXgasmQ91o=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging";
    version = "8.0.1";
    hash = "sha256-vkfVw4tQEg86Xg18v6QO0Qb4Ysz0Njx57d1XcNuj6IU=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging";
    version = "9.0.0";
    hash = "sha256-kR16c+N8nQrWeYLajqnXPg7RiXjZMSFLnKLEs4VfjcM=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.Abstractions";
    version = "9.0.0";
    hash = "sha256-iBTs9twjWXFeERt4CErkIIcoJZU1jrd1RWCI8V5j7KU=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.Configuration";
    version = "8.0.0";
    hash = "sha256-mzmstNsVjKT0EtQcdAukGRifD30T82BMGYlSu8k4K7U=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.Configuration";
    version = "9.0.0";
    hash = "sha256-ysPjBq64p6JM4EmeVndryXnhLWHYYszzlVpPxRWkUkw=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.Console";
    version = "9.0.0";
    hash = "sha256-N2t9EUdlS6ippD4Z04qUUyBuQ4tKSR/8TpmKScb5zRw=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.Debug";
    version = "9.0.0";
    hash = "sha256-5W6fP9Eb98U3MTWKeLzSNl2cRFpE694OOPjpWp/qTAk=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.EventLog";
    version = "9.0.0";
    hash = "sha256-mIL1I85Ef5+/mXl24odoUpcXet+jCZTRtKCd5z6YUwI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Logging.EventSource";
    version = "9.0.0";
    hash = "sha256-pplZskMsR3gGbs3I0wycGsvIMPIpfWFJpOsR9GkiYRw=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.ObjectPool";
    version = "8.0.4";
    hash = "sha256-QX5nippUEMzbxkf+4ukuCR3GJMZE2HX7UqBx5n3+hOc=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Options";
    version = "8.0.0";
    hash = "sha256-n2m4JSegQKUTlOsKLZUUHHKMq926eJ0w9N9G+I3FoFw=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Options";
    version = "8.0.2";
    hash = "sha256-AjcldddddtN/9aH9pg7ClEZycWtFHLi9IPe1GGhNQys=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Options";
    version = "9.0.0";
    hash = "sha256-DT5euAQY/ItB5LPI8WIp6Dnd0lSvBRP35vFkOXC68ck=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Options.ConfigurationExtensions";
    version = "9.0.0";
    hash = "sha256-r1Z3sEVSIjeH2UKj+KMj86har68g/zybSqoSjESBcoA=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Primitives";
    version = "7.0.0";
    hash = "sha256-AGnfNNDvZDGZ0Er9JQxeyLoUbVH+jfXF3anFr12qk6w=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Primitives";
    version = "8.0.0";
    hash = "sha256-FU8qj3DR8bDdc1c+WeGZx/PCZeqqndweZM9epcpXjSo=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Primitives";
    version = "9.0.0";
    hash = "sha256-ZNLusK1CRuq5BZYZMDqaz04PIKScE2Z7sS2tehU7EJs=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Resilience";
    version = "8.4.0";
    hash = "sha256-a5dpyrYiylYCcXmzhv9OgUoDwA7CZMOR6u9itMedGEI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Telemetry";
    version = "8.4.0";
    hash = "sha256-GANaOuMnXoTPhMa6K+tpMhs0BAgHkyKdpnMjuFri9hI=";
  })
  (fetchNuGet {
    pname = "Microsoft.Extensions.Telemetry.Abstractions";
    version = "8.4.0";
    hash = "sha256-1vwfjlKf/1H4ahksrlTR/6BSTc2CwMfOS2+G9iBW46E=";
  })
  (fetchNuGet {
    pname = "Microsoft.IdentityModel.Abstractions";
    version = "8.0.1";
    hash = "sha256-zPWUKTCfGm4MWcYPU037NzezsFE1g8tEijjQkw5iooI=";
  })
  (fetchNuGet {
    pname = "Microsoft.IdentityModel.JsonWebTokens";
    version = "8.0.1";
    hash = "sha256-Xv9MUnjb66U3xeR9drOcSX5n2DjOCIJZPMNSKjWHo9Y=";
  })
  (fetchNuGet {
    pname = "Microsoft.IdentityModel.Logging";
    version = "8.0.1";
    hash = "sha256-FfwrH/2eLT521Kqw+RBIoVfzlTNyYMqlWP3z+T6Wy2Y=";
  })
  (fetchNuGet {
    pname = "Microsoft.IdentityModel.Protocols";
    version = "8.0.1";
    hash = "sha256-v3DIpG6yfIToZBpHOjtQHRo2BhXGDoE70EVs6kBtrRg=";
  })
  (fetchNuGet {
    pname = "Microsoft.IdentityModel.Tokens";
    version = "8.0.1";
    hash = "sha256-beVbbVQy874HlXkTKarPTT5/r7XR1NGHA/50ywWp7YA=";
  })
  (fetchNuGet {
    pname = "Microsoft.IO.RecyclableMemoryStream";
    version = "3.0.0";
    hash = "sha256-WBXkqxC5g4tJ481sa1uft39LqA/5hx5yOfiTfMRMg/4=";
  })
  (fetchNuGet {
    pname = "Microsoft.NET.StringTools";
    version = "17.6.3";
    hash = "sha256-H2Qw8x47WyFOd/VmgRmGMc+uXySgUv68UISgK8Frsjw=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.App.Host.linux-x64";
    version = "8.0.14";
    hash = "sha256-MO52s0Y/7wkAhY4d+ecz1MT+xe7pMqchsakvcY8pWNA=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.App.Ref";
    version = "8.0.14";
    hash = "sha256-YeIjDhpNaO+7kWYZL0ZrbH+EX3inANNbd7m45cxDwLI=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.App.Runtime.linux-x64";
    version = "8.0.14";
    hash = "sha256-l8clUSsyExPwyZ7oO6Dl/K2Md1mnaNdVEe9G4716yCs=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.App.Runtime.linux-x64";
    version = "9.0.3";
    hash = "sha256-JjdZT5ZyiH+ElaCKF4XwP4UMxj+h+H29U4SNF1EGHsQ=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.App.Runtime.linux-x64";
    version = "9.0.5";
    hash = "sha256-l7wGHrE68f3MxQb+FrfCWRKteNefgpZLfJp8Wfd1/lE=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "1.1.0";
    hash = "sha256-FeM40ktcObQJk4nMYShB61H/E8B7tIKfl9ObJ0IOcCM=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "1.1.1";
    hash = "sha256-8hLiUKvy/YirCWlFwzdejD2Db3DaXhHxT7GSZx/znJg=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "2.1.2";
    hash = "sha256-gYQQO7zsqG+OtN4ywYQyfsiggS2zmxw4+cPXlK+FB5Q=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "5.0.0";
    hash = "sha256-LIcg1StDcQLPOABp4JRXIs837d7z0ia6+++3SF3jl1c=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Targets";
    version = "1.1.0";
    hash = "sha256-0AqQ2gMS8iNlYkrD+BxtIg7cXMnr9xZHtKAuN4bjfaQ=";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Targets";
    version = "1.1.3";
    hash = "sha256-WLsf1NuUfRWyr7C7Rl9jiua9jximnVvzy6nk2D2bVRc=";
  })
  (fetchNuGet {
    pname = "Microsoft.Toolkit.Uwp.Notifications";
    version = "7.1.3";
    hash = "sha256-sygTmtEBzLgQ6dh0Hpq/Cz9x+dcDl73+9maOvZvNbF4=";
  })
  (fetchNuGet {
    pname = "Microsoft.Win32.Registry";
    version = "4.5.0";
    hash = "sha256-WMBXsIb0DgPFPaFkNVxY9b9vcMxPqtgFgijKYMJfV/0=";
  })
  (fetchNuGet {
    pname = "Microsoft.Win32.Registry";
    version = "5.0.0";
    hash = "sha256-9kylPGfKZc58yFqNKa77stomcoNnMeERXozWJzDcUIA=";
  })
  (fetchNuGet {
    pname = "Microsoft.Win32.SystemEvents";
    version = "9.0.0";
    hash = "sha256-sN16l3f89HTDlf80BRZQIIbYg33B4Z0BRtyjDcNf6IU=";
  })
  (fetchNuGet {
    pname = "Microsoft.WindowsDesktop.App.Ref";
    version = "8.0.14";
    hash = "sha256-vcP4Zg0+Bmu981JX1/2C/aOgOomR1PQrlpv3tjBA8Wo=";
  })
  (fetchNuGet {
    pname = "Microsoft.WindowsDesktop.App.Ref";
    version = "9.0.3";
    hash = "sha256-5hBff7l7uWwjF0aaT8dq+/5XWzlMZA5sFH1ziiFGppQ=";
  })
  (fetchNuGet {
    pname = "Microsoft.WindowsDesktop.App.Ref";
    version = "9.0.5";
    hash = "sha256-zT4wHlKj0w5/hkP5rYbqwaGT18E4M4rcx5xR9xX8FqA=";
  })
  (fetchNuGet {
    pname = "Microsoft.WindowsDesktop.App.Ref";
    version = "9.0.6";
    hash = "sha256-iNZD1ywTikw6N2KTHznK02UIICua7dW8Dcfv5nHEhrE=";
  })
  (fetchNuGet {
    pname = "NETStandard.Library";
    version = "1.6.1";
    hash = "sha256-iNan1ix7RtncGWC9AjAZ2sk70DoxOsmEOgQ10fXm4Pw=";
  })
  (fetchNuGet {
    pname = "NETStandard.Library";
    version = "2.0.0";
    hash = "sha256-Pp7fRylai8JrE1O+9TGfIEJrAOmnWTJRLWE+qJBahK0=";
  })
  (fetchNuGet {
    pname = "NETStandard.Library";
    version = "2.0.3";
    hash = "sha256-Prh2RPebz/s8AzHb2sPHg3Jl8s31inv9k+Qxd293ybo=";
  })
  (fetchNuGet {
    pname = "Newtonsoft.Json";
    version = "13.0.1";
    hash = "sha256-K2tSVW4n4beRPzPu3rlVaBEMdGvWSv/3Q1fxaDh4Mjo=";
  })
  (fetchNuGet {
    pname = "Nito.AsyncEx";
    version = "5.1.2";
    hash = "sha256-9o4YLWAHSeApF4E/qNFyaZPh/V9N5JSeF32uquukb5I=";
  })
  (fetchNuGet {
    pname = "Nito.AsyncEx.Context";
    version = "5.1.2";
    hash = "sha256-7BCVYJgZyU2/Z4r8CKajorlzajr6GBUBAbY3AcswPC0=";
  })
  (fetchNuGet {
    pname = "Nito.AsyncEx.Coordination";
    version = "5.1.2";
    hash = "sha256-NHMnIBkGzzuoZL0qHKAwFC35doB08IDvmCQptC2uu2s=";
  })
  (fetchNuGet {
    pname = "Nito.AsyncEx.Interop.WaitHandles";
    version = "5.1.2";
    hash = "sha256-1DgBWnkYggWQk0w2g7Y24Ogl7TJ7bQkc/0NIUFJzN00=";
  })
  (fetchNuGet {
    pname = "Nito.AsyncEx.Oop";
    version = "5.1.2";
    hash = "sha256-1hnCagbt6SLbn+RpasWdBH3pLvqm8kC2Ut2iG75OUMM=";
  })
  (fetchNuGet {
    pname = "Nito.AsyncEx.Tasks";
    version = "5.1.2";
    hash = "sha256-W5jxZZ0pbPHte6TkWTq4FDtHOejvlrdyb1Inw+Yhl4c=";
  })
  (fetchNuGet {
    pname = "Nito.Cancellation";
    version = "1.1.2";
    hash = "sha256-oZKZUymYJiM2AfMpX4pX0FIlut0lEWdy250iVX0w+is=";
  })
  (fetchNuGet {
    pname = "Nito.Collections.Deque";
    version = "1.1.1";
    hash = "sha256-6Pmz6XQ+rY32O21Z3cUDVQsLH+i53LId18UCPTAxRZQ=";
  })
  (fetchNuGet {
    pname = "Nito.Disposables";
    version = "2.2.1";
    hash = "sha256-FKDLUWysqroSHLU2kLjK1m0g417AAPh6n2TIkwiapcM=";
  })
  (fetchNuGet {
    pname = "NLog";
    version = "5.3.2";
    hash = "sha256-b/y/IFUSe7qsSeJ8JVB0VFmJlkviFb8h934ktnn9Fgc=";
  })
  (fetchNuGet {
    pname = "NLog.Extensions.Logging";
    version = "5.3.11";
    hash = "sha256-DP3R51h+9kk06N63U+1C4/JCZTFiADeYTROToAA2R0g=";
  })
  (fetchNuGet {
    pname = "NSec.Cryptography";
    version = "24.4.0";
    hash = "sha256-Av3w6I/Q3lBTUFeyyXYbetPGqklLWcfS6O3KhUPALsQ=";
  })
  (fetchNuGet {
    pname = "NSubstitute";
    version = "5.1.0";
    hash = "sha256-ORpubFd6VoRjA9ZeyZdJPY/xnQXM90O6McMswt8VVG4=";
  })
  (fetchNuGet {
    pname = "Octokit";
    version = "13.0.1";
    hash = "sha256-uxQC+bbmWloIdwndqWUb+FY8iAUsPgxzqfw41EPWuAU=";
  })
  (fetchNuGet {
    pname = "OneOf";
    version = "3.0.271";
    hash = "sha256-tFWy8Jg/XVJfVOddjXeCAizq/AUljJrq6J8PF6ArYSU=";
  })
  (fetchNuGet {
    pname = "OneOf.SourceGenerator";
    version = "3.0.271";
    hash = "sha256-FYHl2i6Ce7NJqvS93tbVazqS7GmYF+Ce/Lz6+sqYcQE=";
  })
  (fetchNuGet {
    pname = "OpenIddict.Abstractions";
    version = "5.8.0";
    hash = "sha256-mR+fOkvgzs6zjWzDqBIVJiRXjjXpPsSvzesqrdZ/Ug4=";
  })
  (fetchNuGet {
    pname = "OpenIddict.Client";
    version = "5.8.0";
    hash = "sha256-AtUeanz8u38oCx7K1+Vru5RqhxKe88hHsYVkbLK3Zx8=";
  })
  (fetchNuGet {
    pname = "OpenIddict.Client.SystemNetHttp";
    version = "5.8.0";
    hash = "sha256-8rzCqHnfHWFwL6QvpCciREZfi74OxAzPpiUvU13Lh1k=";
  })
  (fetchNuGet {
    pname = "Polly";
    version = "8.5.0";
    hash = "sha256-oXIqYMkFXoF/9y704LJSX5Non9mry19OSKA7JFviu5Q=";
  })
  (fetchNuGet {
    pname = "Polly.Contrib.WaitAndRetry";
    version = "1.1.1";
    hash = "sha256-InJ8IXAsZDAR4B/YzWCuEWRa/6Xf5oB049UJUkTOoSg=";
  })
  (fetchNuGet {
    pname = "Polly.Core";
    version = "8.3.0";
    hash = "sha256-qyPXFNPWKLWcdxK1NzeIq/f6W2Cx+18dRSW7m/dTc5k=";
  })
  (fetchNuGet {
    pname = "Polly.Core";
    version = "8.4.2";
    hash = "sha256-4fn5n6Bu29uqWg8ciii3MDsi9bO2/moPa9B3cJ9Ihe8=";
  })
  (fetchNuGet {
    pname = "Polly.Core";
    version = "8.5.0";
    hash = "sha256-vN/OoQi5F8+oKNO46FwjPcKrgfhGMGjAQ2yCQUlHtOc=";
  })
  (fetchNuGet {
    pname = "Polly.Extensions";
    version = "8.3.0";
    hash = "sha256-6PgkUTxssOwR7eY0nogvXnQzAhOZYQ+BcshODhAftwg=";
  })
  (fetchNuGet {
    pname = "Polly.Extensions";
    version = "8.4.2";
    hash = "sha256-oyf9CNi8NXLyeMLwBBCifFvV6erIEaurs8i9BZdr0ik=";
  })
  (fetchNuGet {
    pname = "Polly.Extensions.Http";
    version = "3.0.0";
    hash = "sha256-m/DfApduj4LIW9cNjUGit703sMzMLz0MdG0VXQGdJoA=";
  })
  (fetchNuGet {
    pname = "Polly.RateLimiting";
    version = "8.3.0";
    hash = "sha256-T6rhLYx9natuG6rDrgl1i+6HPgcVdqT+DV7Zl/3jYiE=";
  })
  (fetchNuGet {
    pname = "Projektanker.Icons.Avalonia";
    version = "9.4.0";
    hash = "sha256-SVzkayPUk/7WXQW2Wn3ri4ia92WvJoXTrPmcT8C+J8U=";
  })
  (fetchNuGet {
    pname = "Projektanker.Icons.Avalonia.FontAwesome";
    version = "9.4.0";
    hash = "sha256-NscqtIdfn4vWrZbPeJuBq+w6ysAIOLXm3FI8TYUJv4M=";
  })
  (fetchNuGet {
    pname = "Punchclock";
    version = "3.4.143";
    hash = "sha256-ONfHkX2B2uwcc/kUiIZbfv3R17SlVas9OmAcRwMXtLM=";
  })
  (fetchNuGet {
    pname = "pythonnet";
    version = "3.0.3";
    hash = "sha256-O2b4W6c8Y6PVM7NaU5rz/rMXpM5zfCGWC3GP8Frb0WI=";
  })
  (fetchNuGet {
    pname = "Refit";
    version = "8.0.0";
    hash = "sha256-YORvtZtDy0+wlUoJTur1lO5wJMovFY/jxoIvfkEkObI=";
  })
  (fetchNuGet {
    pname = "Refit.HttpClientFactory";
    version = "8.0.0";
    hash = "sha256-VNVCqzq3HwPSRK/GrcBkbdhb2iRYrqoeDBvGnPNyrbA=";
  })
  (fetchNuGet {
    pname = "RockLib.Reflection.Optimized";
    version = "3.0.0";
    hash = "sha256-Ba+VsEusnFJPHYqMJSTduRw+YQiXAru26QZJMxBZbQs=";
  })
  (fetchNuGet {
    pname = "runtime.any.System.IO";
    version = "4.3.0";
    hash = "sha256-vej7ySRhyvM3pYh/ITMdC25ivSd0WLZAaIQbYj/6HVE=";
  })
  (fetchNuGet {
    pname = "runtime.any.System.Reflection";
    version = "4.3.0";
    hash = "sha256-ns6f++lSA+bi1xXgmW1JkWFb2NaMD+w+YNTfMvyAiQk=";
  })
  (fetchNuGet {
    pname = "runtime.any.System.Reflection.Primitives";
    version = "4.3.0";
    hash = "sha256-LkPXtiDQM3BcdYkAm5uSNOiz3uF4J45qpxn5aBiqNXQ=";
  })
  (fetchNuGet {
    pname = "runtime.any.System.Runtime";
    version = "4.3.0";
    hash = "sha256-qwhNXBaJ1DtDkuRacgHwnZmOZ1u9q7N8j0cWOLYOELM=";
  })
  (fetchNuGet {
    pname = "runtime.any.System.Text.Encoding";
    version = "4.3.0";
    hash = "sha256-Q18B9q26MkWZx68exUfQT30+0PGmpFlDgaF0TnaIGCs=";
  })
  (fetchNuGet {
    pname = "runtime.any.System.Threading.Tasks";
    version = "4.3.0";
    hash = "sha256-agdOM0NXupfHbKAQzQT8XgbI9B8hVEh+a/2vqeHctg4=";
  })
  (fetchNuGet {
    pname = "runtime.native.System";
    version = "4.3.0";
    hash = "sha256-ZBZaodnjvLXATWpXXakFgcy6P+gjhshFXmglrL5xD5Y=";
  })
  (fetchNuGet {
    pname = "runtime.unix.System.Private.Uri";
    version = "4.3.0";
    hash = "sha256-c5tXWhE/fYbJVl9rXs0uHh3pTsg44YD1dJvyOA0WoMs=";
  })
  (fetchNuGet {
    pname = "Salaros.ConfigParser";
    version = "0.3.8";
    hash = "sha256-XW/IamPvil2DwZGMJOcbSo/pd0Zxe0vJb/4oJDorOCk=";
  })
  (fetchNuGet {
    pname = "Semi.Avalonia";
    version = "11.2.0";
    hash = "sha256-K8LmaUBTCgTeLD4f0issctaUOjlyFfz2EXHrzAu92x8=";
  })
  (fetchNuGet {
    pname = "Semver";
    version = "3.0.0-beta.1";
    hash = "sha256-eR0KSyhjLvfTJbLb80kgDWq7ffHRe2hRbDUeQC8h/dQ=";
  })
  (fetchNuGet {
    pname = "Sentry";
    version = "4.9.0";
    hash = "sha256-kkWDIoicF/9VtMs5QAYZcHfryTKtMFZKb5CzqUQ7R/o=";
  })
  (fetchNuGet {
    pname = "Sentry";
    version = "5.5.1";
    hash = "sha256-PgcBHyB5KQtDrelzqZKzu+7bzmVl1kdOLFWeTspPbIQ=";
  })
  (fetchNuGet {
    pname = "Sentry.NLog";
    version = "4.9.0";
    hash = "sha256-whIz9EKHwSfwu6b6a6Vloa1dJYrpyuPPQtaVZCYDBKI=";
  })
  (fetchNuGet {
    pname = "Sentry.NLog";
    version = "5.5.1";
    hash = "sha256-u7JKQt8tm/rVSbvvv2PYRY5DIihap02V9V9r+4lnzcs=";
  })
  (fetchNuGet {
    pname = "SharpCompress";
    version = "0.37.2";
    hash = "sha256-IP7/ssqWKT85YwLKrLGACHo0sgp7sMe603X+o485sYo=";
  })
  (fetchNuGet {
    pname = "ShimSkiaSharp";
    version = "2.0.0.2";
    hash = "sha256-Q1ok5/R8FWDCQubbhPsbRWigGqfiADFYUoiLlCvk/20=";
  })
  (fetchNuGet {
    pname = "SkiaSharp";
    version = "3.0.0-preview.4.1";
    hash = "sha256-2i91r01Lr7zkoqLEpoexYf1fdDKWvssiTdBQ2Gi6PZo=";
  })
  (
    (fetchNuGet {
      pname = "SkiaSharp.NativeAssets.Linux";
      version = "3.0.0-preview.4.1";
      hash = "sha256-rGT46uSMhP1J3dmeSN+NOZINrdG191wzFPkz+cZ/8vM=";
    }).overrideAttrs
    (old: {
      buildInputs = old.buildInputs ++ [
        musl
        fontconfig
      ];
    })
  )
  (fetchNuGet {
    pname = "SkiaSharp.NativeAssets.macOS";
    version = "3.0.0-preview.4.1";
    hash = "sha256-r0/zxdlJ5QmfANtaEwgafplGQSEuhVm8WsNWuGoy2Zg=";
  })
  (fetchNuGet {
    pname = "SkiaSharp.NativeAssets.WebAssembly";
    version = "2.88.9";
    hash = "sha256-vgFL4Pdy3O1RKBp+T9N3W4nkH9yurZ0suo8u3gPmmhY=";
  })
  (fetchNuGet {
    pname = "SkiaSharp.NativeAssets.Win32";
    version = "3.0.0-preview.4.1";
    hash = "sha256-FbL9s2JyvT21ulke+o9sCYNmU4LvlybMt3LFVvwwaeY=";
  })
  (fetchNuGet {
    pname = "SpacedGrid-Avalonia";
    version = "11.0.0";
    hash = "sha256-U4WezNpOWtdaK6wh0tVRLoK31mLCdFWVB1xLqok9izw=";
  })
  (fetchNuGet {
    pname = "Splat";
    version = "15.0.1";
    hash = "sha256-IDI88gPTOHrBBp4fIwT85K7CkK1AK1FJwgQkCHrgZg0=";
  })
  (fetchNuGet {
    pname = "Svg.Custom";
    version = "2.0.0.2";
    hash = "sha256-6sWw1V2oPdLgLDybH/FT/hUo+CKZiaIfOYv0KUaiTxk=";
  })
  (fetchNuGet {
    pname = "Svg.Model";
    version = "2.0.0.2";
    hash = "sha256-TGkz0qMKvvjMdliqHEsJE1rqKIbezUZrkjofKRduAk8=";
  })
  (fetchNuGet {
    pname = "Sylvan.Common";
    version = "0.4.3";
    hash = "sha256-PkIxpjb4PKTTxqXDUKcT196oRMUabqwB0Po24AHjR/4=";
  })
  (fetchNuGet {
    pname = "Sylvan.Data";
    version = "0.2.16";
    hash = "sha256-a3xAjNu+Y+bBldnka6Hmmi1Vnwevcd+vsskQ+DNSkcA=";
  })
  (fetchNuGet {
    pname = "Sylvan.Data.Csv";
    version = "1.3.9";
    hash = "sha256-PF39tZrcA9sWxm66BnqMjIEsiUJVMBbCSFYdELa2PPI=";
  })
  (fetchNuGet {
    pname = "System.Buffers";
    version = "4.5.1";
    hash = "sha256-wws90sfi9M7kuCPWkv1CEYMJtCqx9QB/kj0ymlsNaxI=";
  })
  (fetchNuGet {
    pname = "System.CodeDom";
    version = "8.0.0";
    hash = "sha256-uwVhi3xcvX7eiOGQi7dRETk3Qx1EfHsUfchZsEto338=";
  })
  (fetchNuGet {
    pname = "System.Collections.Immutable";
    version = "1.7.1";
    hash = "sha256-WMMAUqoxT3J1gW9DI8v31VAuhwqTc4Posose5jq1BNo=";
  })
  (fetchNuGet {
    pname = "System.Collections.Immutable";
    version = "8.0.0";
    hash = "sha256-F7OVjKNwpqbUh8lTidbqJWYi476nsq9n+6k0+QVRo3w=";
  })
  (fetchNuGet {
    pname = "System.ComponentModel.Annotations";
    version = "5.0.0";
    hash = "sha256-0pST1UHgpeE6xJrYf5R+U7AwIlH3rVC3SpguilI/MAg=";
  })
  (fetchNuGet {
    pname = "System.Composition";
    version = "8.0.0";
    hash = "sha256-rA118MFj6soKN++BvD3y9gXAJf0lZJAtGARuznG5+Xg=";
  })
  (fetchNuGet {
    pname = "System.Composition.AttributedModel";
    version = "8.0.0";
    hash = "sha256-n3aXiBAFIlQicSRLiNtLh++URSUxRBLggsjJ8OMNRpo=";
  })
  (fetchNuGet {
    pname = "System.Composition.Convention";
    version = "8.0.0";
    hash = "sha256-Z9HOAnH1lt1qc38P3Y0qCf5gwBwiLXQD994okcy53IE=";
  })
  (fetchNuGet {
    pname = "System.Composition.Hosting";
    version = "8.0.0";
    hash = "sha256-axKJC71oKiNWKy66TVF/c3yoC81k03XHAWab3mGNbr0=";
  })
  (fetchNuGet {
    pname = "System.Composition.Runtime";
    version = "8.0.0";
    hash = "sha256-AxwZ29+GY0E35Pa255q8AcMnJU52Txr5pBy86t6V1Go=";
  })
  (fetchNuGet {
    pname = "System.Composition.TypedParts";
    version = "8.0.0";
    hash = "sha256-+ZJawThmiYEUNJ+cB9uJK+u/sCAVZarGd5ShZoSifGo=";
  })
  (fetchNuGet {
    pname = "System.Configuration.ConfigurationManager";
    version = "8.0.0";
    hash = "sha256-xhljqSkNQk8DMkEOBSYnn9lzCSEDDq4yO910itptqiE=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.DiagnosticSource";
    version = "4.7.1";
    hash = "sha256-l2TM1pfyRF70Xmzoz1dAqWkB8+/K6b8t5Tj7aF1UO9Y=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.DiagnosticSource";
    version = "8.0.0";
    hash = "sha256-+aODaDEQMqla5RYZeq0Lh66j+xkPYxykrVvSCmJQ+Vs=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.DiagnosticSource";
    version = "9.0.0";
    hash = "sha256-1VzO9i8Uq2KlTw1wnCCrEdABPZuB2JBD5gBsMTFTSvE=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.EventLog";
    version = "6.0.0";
    hash = "sha256-zUXIQtAFKbiUMKCrXzO4mOTD5EUphZzghBYKXprowSM=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.EventLog";
    version = "8.0.0";
    hash = "sha256-rt8xc3kddpQY4HEdghlBeOK4gdw5yIj4mcZhAVtk2/Y=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.EventLog";
    version = "9.0.0";
    hash = "sha256-tPvt6yoAp56sK/fe+/ei8M65eavY2UUhRnbrREj/Ems=";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.PerformanceCounter";
    version = "8.0.0";
    hash = "sha256-CbTL+orc5YcEJfKbBtr/9p/0rNVVOQPz/fOEaA6Pu5k=";
  })
  (fetchNuGet {
    pname = "System.Drawing.Common";
    version = "9.0.0";
    hash = "sha256-fOGssTUHAkZtPMVCvxzcB39CSXRI+Gj4QFLWkR15iz0=";
  })
  (fetchNuGet {
    pname = "System.IO";
    version = "4.3.0";
    hash = "sha256-ruynQHekFP5wPrDiVyhNiRIXeZ/I9NpjK5pU+HPDiRY=";
  })
  (fetchNuGet {
    pname = "System.IO.Hashing";
    version = "9.0.0";
    hash = "sha256-k6Pdndm5fTD6CB1QsQfP7G+2h4B30CWIsuvjHuBg3fc=";
  })
  (fetchNuGet {
    pname = "System.IO.Pipelines";
    version = "6.0.3";
    hash = "sha256-v+FOmjRRKlDtDW6+TfmyMiiki010YGVTa0EwXu9X7ck=";
  })
  (fetchNuGet {
    pname = "System.IO.Pipelines";
    version = "8.0.0";
    hash = "sha256-LdpB1s4vQzsOODaxiKstLks57X9DTD5D6cPx8DE1wwE=";
  })
  (fetchNuGet {
    pname = "System.IO.Pipelines";
    version = "9.0.0";
    hash = "sha256-vb0NrPjfEao3kfZ0tavp2J/29XnsQTJgXv3/qaAwwz0=";
  })
  (fetchNuGet {
    pname = "System.Management";
    version = "8.0.0";
    hash = "sha256-HwpfDb++q7/vxR6q57mGFgl5U0vxy+oRJ6orFKORfP0=";
  })
  (fetchNuGet {
    pname = "System.Memory";
    version = "4.5.5";
    hash = "sha256-EPQ9o1Kin7KzGI5O3U3PUQAZTItSbk9h/i4rViN3WiI=";
  })
  (fetchNuGet {
    pname = "System.Numerics.Vectors";
    version = "4.4.0";
    hash = "sha256-auXQK2flL/JpnB/rEcAcUm4vYMCYMEMiWOCAlIaqu2U=";
  })
  (fetchNuGet {
    pname = "System.Numerics.Vectors";
    version = "4.5.0";
    hash = "sha256-qdSTIFgf2htPS+YhLGjAGiLN8igCYJnCCo6r78+Q+c8=";
  })
  (fetchNuGet {
    pname = "System.Private.Uri";
    version = "4.3.2";
    hash = "sha256-jB2+W3tTQ6D9XHy5sEFMAazIe1fu2jrENUO0cb48OgU=";
  })
  (fetchNuGet {
    pname = "System.Reactive";
    version = "6.0.0";
    hash = "sha256-hXB18OsiUHSCmRF3unAfdUEcbXVbG6/nZxcyz13oe9Y=";
  })
  (fetchNuGet {
    pname = "System.Reactive";
    version = "6.0.1";
    hash = "sha256-Lo5UMqp8DsbVSUxa2UpClR1GoYzqQQcSxkfyFqB/d4Q=";
  })
  (fetchNuGet {
    pname = "System.Reflection";
    version = "4.3.0";
    hash = "sha256-NQSZRpZLvtPWDlvmMIdGxcVuyUnw92ZURo0hXsEshXY=";
  })
  (fetchNuGet {
    pname = "System.Reflection.Emit";
    version = "4.3.0";
    hash = "sha256-5LhkDmhy2FkSxulXR+bsTtMzdU3VyyuZzsxp7/DwyIU=";
  })
  (fetchNuGet {
    pname = "System.Reflection.Emit";
    version = "4.7.0";
    hash = "sha256-Fw/CSRD+wajH1MqfKS3Q/sIrUH7GN4K+F+Dx68UPNIg=";
  })
  (fetchNuGet {
    pname = "System.Reflection.Emit.ILGeneration";
    version = "4.3.0";
    hash = "sha256-mKRknEHNls4gkRwrEgi39B+vSaAz/Gt3IALtS98xNnA=";
  })
  (fetchNuGet {
    pname = "System.Reflection.Metadata";
    version = "8.0.0";
    hash = "sha256-dQGC30JauIDWNWXMrSNOJncVa1umR1sijazYwUDdSIE=";
  })
  (fetchNuGet {
    pname = "System.Reflection.Primitives";
    version = "4.3.0";
    hash = "sha256-5ogwWB4vlQTl3jjk1xjniG2ozbFIjZTL9ug0usZQuBM=";
  })
  (fetchNuGet {
    pname = "System.Runtime";
    version = "4.3.0";
    hash = "sha256-51813WXpBIsuA6fUtE5XaRQjcWdQ2/lmEokJt97u0Rg=";
  })
  (fetchNuGet {
    pname = "System.Runtime.CompilerServices.Unsafe";
    version = "4.5.2";
    hash = "sha256-8eUXXGWO2LL7uATMZye2iCpQOETn2jCcjUhG6coR5O8=";
  })
  (fetchNuGet {
    pname = "System.Runtime.CompilerServices.Unsafe";
    version = "4.5.3";
    hash = "sha256-lnZMUqRO4RYRUeSO8HSJ9yBHqFHLVbmenwHWkIU20ak=";
  })
  (fetchNuGet {
    pname = "System.Runtime.CompilerServices.Unsafe";
    version = "6.0.0";
    hash = "sha256-bEG1PnDp7uKYz/OgLOWs3RWwQSVYm+AnPwVmAmcgp2I=";
  })
  (fetchNuGet {
    pname = "System.Security.AccessControl";
    version = "4.5.0";
    hash = "sha256-AFsKPb/nTk2/mqH/PYpaoI8PLsiKKimaXf+7Mb5VfPM=";
  })
  (fetchNuGet {
    pname = "System.Security.AccessControl";
    version = "5.0.0";
    hash = "sha256-ueSG+Yn82evxyGBnE49N4D+ngODDXgornlBtQ3Omw54=";
  })
  (fetchNuGet {
    pname = "System.Security.Cryptography.ProtectedData";
    version = "8.0.0";
    hash = "sha256-fb0pa9sQxN+mr0vnXg1Igbx49CaOqS+GDkTfWNboUvs=";
  })
  (fetchNuGet {
    pname = "System.Security.Principal.Windows";
    version = "4.5.0";
    hash = "sha256-BkUYNguz0e4NJp1kkW7aJBn3dyH9STwB5N8XqnlCsmY=";
  })
  (fetchNuGet {
    pname = "System.Security.Principal.Windows";
    version = "4.7.0";
    hash = "sha256-rWBM2U8Kq3rEdaa1MPZSYOOkbtMGgWyB8iPrpIqmpqg=";
  })
  (fetchNuGet {
    pname = "System.Security.Principal.Windows";
    version = "5.0.0";
    hash = "sha256-CBOQwl9veFkrKK2oU8JFFEiKIh/p+aJO+q9Tc2Q/89Y=";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding";
    version = "4.3.0";
    hash = "sha256-GctHVGLZAa/rqkBNhsBGnsiWdKyv6VDubYpGkuOkBLg=";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding.CodePages";
    version = "4.5.1";
    hash = "sha256-PIhkv59IXjyiuefdhKxS9hQfEwO9YWRuNudpo53HQfw=";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding.CodePages";
    version = "7.0.0";
    hash = "sha256-eCKTVwumD051ZEcoJcDVRGnIGAsEvKpfH3ydKluHxmo=";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding.CodePages";
    version = "8.0.0";
    hash = "sha256-fjCLQc1PRW0Ix5IZldg0XKv+J1DqPSfu9pjMyNBp7dE=";
  })
  (fetchNuGet {
    pname = "System.Text.Encodings.Web";
    version = "9.0.0";
    hash = "sha256-WGaUklQEJywoGR2jtCEs5bxdvYu5SHaQchd6s4RE5x0=";
  })
  (fetchNuGet {
    pname = "System.Text.Json";
    version = "9.0.0";
    hash = "sha256-aM5Dh4okLnDv940zmoFAzRmqZre83uQBtGOImJpoIqk=";
  })
  (fetchNuGet {
    pname = "System.Threading.Channels";
    version = "7.0.0";
    hash = "sha256-Cu0gjQsLIR8Yvh0B4cOPJSYVq10a+3F9pVz/C43CNeM=";
  })
  (fetchNuGet {
    pname = "System.Threading.Channels";
    version = "8.0.0";
    hash = "sha256-c5TYoLNXDLroLIPnlfyMHk7nZ70QAckc/c7V199YChg=";
  })
  (fetchNuGet {
    pname = "System.Threading.RateLimiting";
    version = "8.0.0";
    hash = "sha256-KOEWEt6ZthvZHJ2Wp70d9nBhBrPqobGQDi2twlKYh/w=";
  })
  (fetchNuGet {
    pname = "System.Threading.Tasks";
    version = "4.3.0";
    hash = "sha256-Z5rXfJ1EXp3G32IKZGiZ6koMjRu0n8C1NGrwpdIen4w=";
  })
  (fetchNuGet {
    pname = "System.Threading.Tasks.Extensions";
    version = "4.5.4";
    hash = "sha256-owSpY8wHlsUXn5xrfYAiu847L6fAKethlvYx97Ri1ng=";
  })
  (fetchNuGet {
    pname = "System.ValueTuple";
    version = "4.5.0";
    hash = "sha256-niH6l2fU52vAzuBlwdQMw0OEoRS/7E1w5smBFoqSaAI=";
  })
  (fetchNuGet {
    pname = "TextMateSharp";
    version = "1.0.56";
    hash = "sha256-uf0Kt7Wd2GEEbFxXeaLd7fEpLl6LP1ESLOC2/BjNYNk=";
  })
  (fetchNuGet {
    pname = "TextMateSharp.Grammars";
    version = "1.0.56";
    hash = "sha256-KHX4YmDEJ5RRBtCTOC9YSLEGIKqBiZljPM+3ETqH+8s=";
  })
  (fetchNuGet {
    pname = "Tmds.DBus";
    version = "0.9.1";
    hash = "sha256-tT1ocQA6Fr6S7e98awNPayikd8+nHwgXvOumtbSNuyQ=";
  })
  (fetchNuGet {
    pname = "Tmds.DBus.Protocol";
    version = "0.20.0";
    hash = "sha256-CRW/tkgsuBiBJfRwou12ozRQsWhHDooeP88E5wWpWJw=";
  })
  (fetchNuGet {
    pname = "URISchemeTools";
    version = "1.0.2";
    hash = "sha256-10+DfWbrZT65ZpDttChJzzh7VukaNcSG5pGrVWre2IY=";
  })
  (fetchNuGet {
    pname = "Websocket.Client";
    version = "5.1.2";
    hash = "sha256-T0uXa9hAr3+9cvpJ/FVwtqNmE7QvSJxXsIoWV624cHs=";
  })
  (fetchNuGet {
    pname = "XmpCore";
    version = "6.1.10.1";
    hash = "sha256-eEEQz9UJhvlAxRhcRZ8JVIVaa3LkSE1U3NTCiA+JJZg=";
  })
  (fetchNuGet {
    pname = "YamlDotNet";
    version = "16.0.0";
    hash = "sha256-wCKzDkAuIpQ65MKe39Zn/K8iX8FKdkw49OHIi7m6GHU=";
  })
  (fetchNuGet {
    pname = "Yoh.Text.Json.NamingPolicies";
    version = "1.1.2";
    hash = "sha256-NKPgZr2ullaMkUpZJ/fckd/z9aPVp5NMtifSIGZEiUA=";
  })
  (fetchNuGet {
    pname = "ZstdSharp.Port";
    version = "0.8.0";
    hash = "sha256-nQkUIDqpgy7ZAtRWyMXQflYnWdPUcbIxIblOINO2O5k=";
  })
]
