///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ascii - Image Effect.
// Copyright (c) Digital Software/Johan Munkestam. All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

using System;
using UnityEngine;

namespace AsciiImageEffect {
	/// <summary>
	/// Ascii - Image Effect.
	/// </summary>
	[ExecuteInEditMode]
	[RequireComponent(typeof(Camera))]
	[AddComponentMenu("Image Effects/AsciiZarkow")]
	public sealed class AsciiZarkow : MonoBehaviour {
		private Shader shader;

		private Material material;

		private Texture BracketSamplerTexture;
		private Texture AndSamplerTexture;
		private Texture DollarSamplerTexture;
		private Texture RSamplerTexture;
		private Texture PSamplerTexture;
		private Texture AsterixSamplerTexture;
		private Texture PlusSamplerTexture;
		private Texture TildeSamplerTexture;
		private Texture MinusSamplerTexture;
		private Texture DotSamplerTexture;

		private void Awake() {
			shader = Resources.Load<Shader>(@"Shaders/AsciiZarkow");
			if (shader == null) {
				Debug.LogError(@"Ascii shader not found.");

				this.enabled = false;
			}
		}

		/// <summary>
		/// Check.
		/// </summary>
		private void OnEnable() {
			if (SystemInfo.supportsImageEffects == false) {
				Debug.LogError(@"Hardware not support Image Effects.");

				this.enabled = false;
			} else if (shader == null) {
				Debug.LogError(string.Format("'{0}' shader null.", this.GetType().ToString()));

				this.enabled = false;
			} else {
				CreateMaterial();

				if (material == null)
					this.enabled = false;
			}
		}

		/// <summary>
		/// Destroy the material.
		/// </summary>
		private void OnDisable() {
			if (material != null)
				DestroyImmediate(material);
		}

		/// <summary>
		/// Creates the material.
		/// </summary>
		private void CreateMaterial() {
			if (shader != null) {
				if (material != null) {
					if (Application.isEditor == true)
						DestroyImmediate(material);
					else
						Destroy(material);
				}

				material = new Material(shader);
				if (material == null) {
					Debug.LogWarning(string.Format("'{0}' material null.", this.name));
					return;
				}

				{
					BracketSamplerTexture = LoadTexture("ascii_bracket");
					AndSamplerTexture = LoadTexture("ascii_and");
					DollarSamplerTexture = LoadTexture("ascii_dollar");
					RSamplerTexture = LoadTexture("ascii_r");
					PSamplerTexture = LoadTexture("ascii_p");
					AsterixSamplerTexture = LoadTexture("ascii_asterix");
					PlusSamplerTexture = LoadTexture("ascii_plus");
					TildeSamplerTexture = LoadTexture("ascii_tilde");
					MinusSamplerTexture = LoadTexture("ascii_minus");
					DotSamplerTexture = LoadTexture("ascii_dot");

				}
			}
		}

		private Texture LoadTexture(string texturePath) {
			Texture tex = Resources.Load<Texture>("Textures/" + texturePath);
			if (tex == null) {
				Debug.LogError(string.Format("Texture '{0}' not found!", "Textures/" + texturePath));

				return null;
			}

			Debug.Log("Loaded " + texturePath);

			// safety, if forgotten when we added them
			tex.wrapMode = TextureWrapMode.Repeat;
			tex.filterMode = FilterMode.Point;

			return tex;
		}

		private void OnRenderImage(RenderTexture source, RenderTexture destination) {
			if (material != null) {
				material.SetFloat(@"monitorWidthMultiplier", (Screen.width / 9.0f));
				material.SetFloat(@"monitorHeightMultiplier", (Screen.height / 10.0f));

				material.SetTexture(@"BracketSampler", BracketSamplerTexture);
				material.SetTexture(@"AndSampler", AndSamplerTexture);
				material.SetTexture(@"DollarSampler", DollarSamplerTexture);
				material.SetTexture(@"RSampler", RSamplerTexture);
				material.SetTexture(@"PSampler", PSamplerTexture);
				material.SetTexture(@"AsterixSampler", AsterixSamplerTexture);
				material.SetTexture(@"PlusSampler", PlusSamplerTexture);
				material.SetTexture(@"TildeSampler", TildeSamplerTexture);
				material.SetTexture(@"MinusSampler", MinusSamplerTexture);
				material.SetTexture(@"DotSampler", DotSamplerTexture);

				Graphics.Blit(source, destination, material, 0);
			}
		}
	}
}