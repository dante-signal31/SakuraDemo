using Godot;

namespace SakuraDemo.Scripts;

[Tool]
public partial class LeafEmitter : GpuParticles2D
{
    [ExportCategory("CONFIGURATION")] 
    [Export] private int _minimumFlowerAmount = 5;
    [Export] public float OscillationMultiplier { get; set; } = 40.0f; 
    private float _windStrength = 0.0f;

    [Export(
        PropertyHint.Range,
        "0.0, 10.0, 0.001")]
    public float WindStrength
    {
        get => _windStrength;
        set
        {
            if (Mathf.IsEqualApprox(_windStrength, value)) return;
            _windStrength = value;
            Amount = (int) Mathf.Ceil(_minimumFlowerAmount * (1.0 + _windStrength));
        }
    }
    [Export(
        PropertyHint.Range, 
        "-1.0, 1.0, 0.001")] public float HorizontalOffset { get; set; }

    public float Time { get; set; }

    private Vector2 _initialPosition;
    private Vector2 _lastPosition;
    private bool _minimumReached = false;
    private bool _maximumReached = false;

    private float get_oscillation(
        float windStrength,
        float horizontalOffset,
        float time)
    {
        return windStrength * (Mathf.Sin(time) + horizontalOffset);
    }

    public override void _Ready()
    {
        base._Ready();
        _initialPosition = Position;
        Amount = _minimumFlowerAmount;
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        float oscillation = OscillationMultiplier * 
                            get_oscillation(WindStrength, HorizontalOffset, Time);
        Position = _initialPosition with { X = _initialPosition.X + oscillation };
    }
}