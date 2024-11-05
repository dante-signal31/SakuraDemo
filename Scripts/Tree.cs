using Godot;

namespace SakuraDemo.Scripts;

[Tool]
public partial class Tree : Sprite2D
{
    private const string WindStrengthParameterName = "wind_strength";
    private const string HorizontalOffsetParameterName = "horizontal_offset";
    private const string TimeParameterName = "time";
    private const string MaximumOscillationAmplitudeName = "maximum_oscillation_amplitude";

    [ExportCategory("CONFIGURATION")] 
    [Export(PropertyHint.Range, "0.0, 10.0, 0.001")] 
    public float WindStrength
    {
        get
        {
            if (_treeShader == null) return 0.0f;
            return (float) _treeShader.GetShaderParameter(
                WindStrengthParameterName);
        }
        set
        {
            if (_treeShader == null) return;
            if (Mathf.IsEqualApprox(WindStrength,value)) return;
            _treeShader.SetShaderParameter(
                WindStrengthParameterName, 
                value);
            _flowersEmitter.WindStrength = value;
        }
    }
    
    [Export(PropertyHint.Range, "-1.0, 1.0, 0.001")] 
    public float HorizontalOffset
    {
        get {
            if (_treeShader == null) return 0.0f;
            return (float) _treeShader.GetShaderParameter(
                HorizontalOffsetParameterName);
        }
        set
        {
            if (_treeShader == null) return;
            if (Mathf.IsEqualApprox(HorizontalOffset,value)) return;
            _treeShader.SetShaderParameter(
                HorizontalOffsetParameterName, 
                value);
            _flowersEmitter.HorizontalOffset = value;
        }
    }
    
    [Export]
    private float MaximumOscillationAmplitude
    {
        get
        {
            if (_treeShader == null) return 0.0f;
            return (float) _treeShader.GetShaderParameter(
                MaximumOscillationAmplitudeName);
        }
        set
        {
            if (_treeShader == null) return;
            if (Mathf.IsEqualApprox(MaximumOscillationAmplitude,value)) return;
            _treeShader.SetShaderParameter(
                MaximumOscillationAmplitudeName, 
                value);
            _flowersEmitter.OscillationMultiplier = value;
        }
    }

    [ExportGroup("WIRING:")] 
    [Export] private LeafEmitter _flowersEmitter;
    
    private float _time;
    public float Time
    {
        get => _time;
        set
        { 
            if (_treeShader == null) return;
            _treeShader.SetShaderParameter(TimeParameterName, value);
            if (_flowersEmitter != null) _flowersEmitter.Time = value;
            _time = value;
        }
    }
    private ShaderMaterial _treeShader;
    
    public override void _EnterTree()
    {
        _treeShader = (ShaderMaterial) Material;
        _flowersEmitter.WindStrength = WindStrength;
        _flowersEmitter.HorizontalOffset = HorizontalOffset;
        _flowersEmitter.OscillationMultiplier = MaximumOscillationAmplitude;
        _flowersEmitter.Time = Time;
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        Time += (float) delta;
    }
}